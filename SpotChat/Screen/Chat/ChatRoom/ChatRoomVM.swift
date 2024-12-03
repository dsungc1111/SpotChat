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
    
    private let realmRepository = RealmRepository()
    
    struct Input {
        let trigger = PassthroughSubject<String, Never>()
        let sendMessage = PassthroughSubject<SocketDMModel, Never>()
        let imageDataList = CurrentValueSubject<[Data], Never>([])
    }
    
    struct Output {
        let chatList: CurrentValueSubject<[ChatMessage], Never>
        let socketChatList: PassthroughSubject<SocketDMModel, Never>
    }
    
    @Published
    var input = Input()
    
    private let socketManager: SocketProvider
    
    init( socketManager: SocketProvider) { self.socketManager = socketManager }
    
    func transform(input: Input) -> Output {
        
        let chatList = CurrentValueSubject<[ChatMessage], Never>([])
        let socketChatList = PassthroughSubject<SocketDMModel, Never>()
        
        input.trigger
            .sink { [weak self] roomID in
                guard let self else { return }
                
                Task { [weak self] in
                    guard let self else { return }
                    
                    // 저장된 내역 중 최신 시간 가져와서
                    let createdAt =  self.realmRepository.fetchRecentDate(for: roomID)
                    // 그 이후의 내역 서버에서 전달 받고
                    let result = try await NetworkManager2.shared.performRequest(router: .getChatContent(roomID, createdAt), responseType: GetChattingContentModel.self)
                    // 저장
                    if !result.data.isEmpty {
                        realmRepository.saveUnreadChat(chat: result.data)
                    }
                    // 데이터 20 + @ 개 가져오기
                    let savedChat = realmRepository.fetchSavedChat(unread: result.data.count)
                    chatList.send(savedChat)
                    // 데이터 ui 로드 후 소켓 연결
                    socketManager.connect()
                }
            }
            .store(in: &cancellables)
        
        socketManager.socketSubject
            .sink { [weak self] _ in
                guard let self else { return }
                
                var updatedChatList = chatList.value
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    let newChatList = self.realmRepository.fetchLatestChat()[0]
                    updatedChatList.append(newChatList)
                    chatList.send([newChatList])
                })
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
                        
                        // 메시지 전송
                        let result = try await NetworkManager2.shared.performRequest(
                            router: .sendChat(message.roomID, sendChatModel),
                            responseType: LastChat.self
                        )
                        
                        socketManager.sendMessage(message)
                        print("⚫️⚫️⚫️⚫️⚫️⚫️ 메시지 전송 성공: \(result)")
                    } catch {
                        print("🔴🔴🔴🔴🔴🔴 메시지 전송 실패: \(error)")
                    }
                }
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
