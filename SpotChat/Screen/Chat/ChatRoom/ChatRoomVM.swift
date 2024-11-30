//
//  ChatRoomVM.swift
//  SpotChat
//
//  Created by 최대성 on 11/26/24.
//

import Foundation
import Combine

final class ChatRoomVM: BaseVMProtocol {
    
    var cancellables = Set<AnyCancellable>()
    
    
    struct Input {
        let trigger = PassthroughSubject<String, Never>()
        let sendMessage = PassthroughSubject<SocketDMModel, Never>()
        let imageDataList = CurrentValueSubject<[Data], Never>([])
    }
    
    struct Output {
        let chatList: PassthroughSubject<[LastChat], Never>
        let socketChatList: PassthroughSubject<SocketDMModel, Never>
    }
    
    @Published
    var input = Input()
    
    let socketManager: SocketProvider
    
    init( socketManager: SocketProvider) {
        
        self.socketManager = socketManager
        
        socketManager.connect()
    }
    
    func transform(input: Input) -> Output {
        
        
        let chatList = PassthroughSubject<[LastChat], Never>()
        let socketChatList = PassthroughSubject<SocketDMModel, Never>()
        
        input.trigger
            .sink { roomID in
                Task {
                    let result = try await NetworkManager2.shared.performRequest(router: .getChatContent(roomID, nil), responseType: GetChattingContentModel.self)
                    
                    
                    
                    chatList.send(result.data)
                }
            }
            .store(in: &cancellables)
        
        input.sendMessage
            .sink { [weak self] message in
                guard let self else { return }
                
                Task {
                    do {
                        
//                        let postImageQuery = PostImageQuery(imageData: input.imageDataList.value.first)
//                        print("🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎 = ", postImageQuery)
//                        
//                        let fileUpload = try await NetworkManager2.shared.performRequest(router: .sendFiles(message.roomID, postImageQuery), responseType: PostImageModel.self)
//                        //
//                        print("👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹", fileUpload)
                        
                        let sendChatModel = SendChatQuery(content: message.content ?? "" , files: [])
//                        print("👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹👹", sendChatModel)
                        let result = try await NetworkManager2.shared.performRequest(router: .sendChat(message.roomID, sendChatModel), responseType: LastChat.self)
                        self.socketManager.sendMessage(message)
                        print("⚫️⚫️⚫️⚫️⚫️⚫️ 메시지 전송 성공: \(result)")
                    } catch let error {
                        print("🔴🔴🔴🔴🔴🔴 메시지 전송 실패: \(error)")
                    }
                }
                
            }
            .store(in: &cancellables)
        
        socketManager.socketSubject
            .sink { chatting in
                socketChatList.send(chatting)
            }
            .store(in: &cancellables)
        
        
        return Output(chatList: chatList, socketChatList: socketChatList)
    }
    
}
