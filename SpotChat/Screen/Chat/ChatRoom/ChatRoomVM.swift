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
        
//        socketManager.connect()
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

                Task { [weak self] in
                    guard let self else { return }
                    do {
                        // 이미지 데이터 여부에 따라 모델 생성
                        let sendChatModel = try await createSendChatModel(message: message, imageDataList: input.imageDataList.value)

//                        // 메시지 전송
//                        let result = try await NetworkManager2.shared.performRequest(
//                            router: .sendChat(message.roomID, sendChatModel),
//                            responseType: LastChat.self
//                        )

//                        socketManager.sendMessage(message)
//                        print("⚫️⚫️⚫️⚫️⚫️⚫️ 메시지 전송 성공: \(result)")
                    } catch {
                        print("🔴🔴🔴🔴🔴🔴 메시지 전송 실패: \(error)")
                    }
                }
            }
            .store(in: &cancellables)
        
        
        
        
        socketManager.socketSubject
            .sink { chatting in
                print("🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴얘가 지금 받고있는거야?")
                socketChatList.send(chatting)
            }
            .store(in: &cancellables)
        
        
        return Output(chatList: chatList, socketChatList: socketChatList)
    }
    
    
    private func createSendChatModel(message: SocketDMModel, imageDataList: [Data]) async throws -> SendChatQuery {
        var sendChatModel = SendChatQuery(content: message.content ?? "", files: [])

        if !imageDataList.isEmpty {
            print("🍎🍎🍎 이미지 데이터 처리 시작")
            
            let postImageQuery = PostImageQuery(imageData: imageDataList)
            print("🍎🍎🍎 PostImageQuery 생성 완료: \(postImageQuery)")
            
            let fileUpload = try await NetworkManager2.shared.performRequest(
                router: .sendFiles(message.roomID, postImageQuery),
                responseType: PostImageModel.self
            )
            
            print("🟣🟣🟣 파일 업로드 성공: \(fileUpload)")
            sendChatModel.files = fileUpload.files
        } else {
            print("🥎🥎🥎 이미지가 없으므로 빈 파일 목록으로 처리")
        }

        print("👹👹👹 SendChatQuery 생성 완료: \(sendChatModel)")
        return sendChatModel
    }
}
