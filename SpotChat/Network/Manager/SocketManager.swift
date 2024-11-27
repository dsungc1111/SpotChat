//
//  SocketManager.swift
//  SpotChat
//
//  Created by 최대성 on 11/26/24.
//


import Combine
import SocketIO
import Foundation

protocol SocketProvider {
    var socketSubject: PassthroughSubject<SocketDMModel, Never> { get }
    
    func connect()
    func disconnect()
    func sendMessage(_ message: SocketDMModel) // 메시지 전송 메서드
}

final class SocketNetworkManager: SocketProvider {
    
    private var manager: SocketManager
    private var socket: SocketIOClient
    private var messages: [Message] = []
    
    var socketSubject = PassthroughSubject<SocketDMModel, Never>()
    
    init(roomID: String) {
        guard let url = URL(string: APIKey.socketBaseURL + roomID) else {
            fatalError("Invalid Socket URL")
        }
        print("🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴", url)
        print("🟤🟤🟤🟤🟤🟤🟤🟤🟤🟤🟤🟤🟤🟤\(roomID)")
        manager = SocketManager(socketURL: url, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }
    
    func configureSocketEvent() {
        print("✅✅✅✅✅✅✅")
        // 소켓 연결 이벤트
        socket.on(clientEvent: .connect) { data, ack in
            print("✨ Socket 연결!!!!!!")
        }
        // 서버에서 전달된 데이터 출력 이벤트
        socket.on("chat") { [weak self] dataArr, ack in
            print("📮 Chat Message Received: \(dataArr)")
            self?.handleIncomingMessage(dataArr)
        }
        
        // 소켓 연결 해제 이벤트
        socket.on(clientEvent: .disconnect) { data, ack in
            print("⛓️‍💥 Socket XXXXXXX")
        }
        
        // 소켓 재연결 이벤트
        socket.on(clientEvent: .reconnect) { data, ack in
            print("🔄 Socket Reconnecting")
        }
    }
    
    private func handleIncomingMessage(_ dataArr: [Any]) {
        print(#function, "그럼 여기라도 🥺🥺🥺🥺🥺🥺🥺🥺🥺🥺🥺🥺🥺")
        do {
            guard let data = dataArr.first else { return }
            let jsonData = try JSONSerialization.data(withJSONObject: data)
            let decodedData = try JSONDecoder().decode(SocketDMModel.self, from: jsonData)
            print("👇 Decoded Chat Message: \(decodedData)")
            
            let isSentByUser = decodedData.sender.userID == UserDefaultsManager.userId
            let message = Message(content: decodedData.content, isSentByUser: isSentByUser)
            
            DispatchQueue.main.async { [weak self] in
                self?.messages.append(message)
            }
        } catch {
            print("🚨 Failed to decode chat message: \(error)")
        }
    }
    
    func sendMessage(_ message: SocketDMModel) {
        do {
            let jsonData = try JSONEncoder().encode(message)
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                socket.emit("chat", jsonObject) // 서버에 "send_chat" 이벤트로 전송
                print("📤 Sent Message: \(message)")
            }
        } catch {
            print("🚨 Failed to encode message: \(error)")
        }
    }
    
    func removeSocketEvent() {
        print(#function)
        socket.off(clientEvent: .connect)
        socket.off(clientEvent: .disconnect)
        socket.off("chat")
        socket.off(clientEvent: .reconnect)
    }
    
    func connect() {
        configureSocketEvent()
        socket.connect()
        print("🌀 Connecting to socket...")
    }
    
    func disconnect() {
        removeSocketEvent()
        socket.disconnect()
        print("⛔ Disconnected from socket.")
    }
}
