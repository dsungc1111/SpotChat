//
//  ChatRoomVM.swift
//  SpotChat
//
//  Created by 최대성 on 11/26/24.
//

import Combine
import Foundation

final class ChatRoomVM: BaseVMProtocol {
    var cancellables = Set<AnyCancellable>()
    
    private let realmRepository = RealmRepository()
    private let socketManager: SocketProvider
    private let pageSize = 20
    private var currentOffset = 0
    private var isLoading = false
    
    var chatList = CurrentValueSubject<[ChatMessage], Never>([])
    
    struct Input {
        let trigger = PassthroughSubject<String, Never>() // RoomID 트리거
        let sendMessage = PassthroughSubject<SocketDMModel, Never>() // 메시지 전송
        let imageDataList = CurrentValueSubject<[Data], Never>([]) // 이미지 데이터
    }
    
    struct Output {
        let chatList: CurrentValueSubject<[ChatMessage], Never> // UI에 로드할 메시지 목록
        let socketChatList: PassthroughSubject<SocketDMModel, Never> // 소켓에서 받은 메시지
    }
    
    @Published
    var input = Input()
    
    init(socketManager: SocketProvider) {
        self.socketManager = socketManager
        realmRepository.fetchRealmURL()
    }
    
    func transform(input: Input) -> Output {
        let chatList = CurrentValueSubject<[ChatMessage], Never>([])
        let socketChatList = PassthroughSubject<SocketDMModel, Never>()
        
        input.trigger
            .sink { [weak self] roomID in
                guard let self else { return }
                print("ㅅㅂ1")
                handleTrigger(roomID: roomID, chatList: chatList)
                print("ㅅㅂ2")
            }
            .store(in: &cancellables)
        
        socketManager.socketSubject
            .sink { [weak self] socketMessage in
                guard let self else { return }
                handleSocketMessage(socketMessage, chatList: chatList)
            }
            .store(in: &cancellables)
        
        input.sendMessage
            .sink { [weak self] message in
                guard let self else { return }
                handleSendMessage(message, imageDataList: input.imageDataList.value)
            }
            .store(in: &cancellables)
        
        return Output(chatList: chatList, socketChatList: socketChatList)
    }
    
    
    
}


extension ChatRoomVM {
    
    func fetchMoreChatsIfNeeded(for roomID: String, currentIndex: Int) {
        
        guard !isLoading else { return } // 이미 로딩 중이라면 요청 차단
        guard currentIndex < chatList.value.count - 2 else {
            print("도달 못함")
            return
        } // 임계값 도달 시만 요청
        
        print("맻기야!!!!!", currentIndex)
        isLoading = true
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let additionalChats = self.realmRepository.fetchChats(
                roomID: roomID,
                offset: self.currentOffset,
                limit: self.pageSize
            )
            
            DispatchQueue.main.async {
                self.chatList.value.append(contentsOf: additionalChats)
                self.currentOffset += additionalChats.count
                self.isLoading = false
            }
        }
    }
    
    
    private func handleTrigger(roomID: String, chatList: CurrentValueSubject<[ChatMessage], Never>) {
        
        synchronizeDataForRoom(roomID: roomID) { [weak self] in
            guard let self else { return }
            
            // Realm에서 저장된 메시지 20개 + 서버에서 추가로 가져온 메시지 개수만큼 가져옴
            let savedChat = self.realmRepository.fetchSavedChat(unread: 0, roomID: roomID) // unread 계산 필요 시 적용
            chatList.send(savedChat)
            
            // 소켓 연결
            self.socketManager.connect()
        }
    }
    
    
    private func synchronizeDataForRoom(roomID: String, completion: @escaping () -> Void) {
        Task {
            // Realm에서 마지막 메시지의 createdAt 값을 가져옴
            let lastCreatedAt = realmRepository.fetchRecentDate(for: roomID)
            
            do {
                // 서버에서 createdAt 이후의 메시지를 가져옴
                let result = try await NetworkManager2.shared.performRequest(
                    router: .getChatContent(roomID, lastCreatedAt),
                    responseType: GetChattingContentModel.self
                )
                
                // 서버에서 가져온 메시지를 Realm에 저장
                if !result.data.isEmpty {
                    realmRepository.saveUnreadChat(chat: result.data)
                }
                
                print("🔵 동기화 완료: \(result.data.count)개의 메시지가 저장됨")
                completion()
            } catch {
                print("🔴 데이터 동기화 실패: \(error)")
                completion() // 실패하더라도 UI 업데이트를 위해 completion 호출
            }
        }
    }
    
    private func handleSocketMessage(_ socketMessage: SocketDMModel, chatList: CurrentValueSubject<[ChatMessage], Never>) {
        Task {
            realmRepository.saveChatMessage(chat: socketMessage)
            let latestMessage = realmRepository.fetchLatestChat()[0]
            var updatedChatList = chatList.value
            updatedChatList.append(latestMessage)
            chatList.send([latestMessage])
            
        }
    }
    
    private func handleSendMessage(_ message: SocketDMModel, imageDataList: [Data]) {
        Task {
            do {
                let sendChatModel = try await createSendChatModel(message: message, imageDataList: imageDataList)
                let result = try await NetworkManager2.shared.performRequest(
                    router: .sendChat(message.roomID, sendChatModel),
                    responseType: LastChat.self
                )
                socketManager.sendMessage(message)
                print("메시지 전송 성공:", result)
            } catch {
                print("메시지 전송 실패:", error)
            }
        }
    }
    
    private func createSendChatModel(message: SocketDMModel, imageDataList: [Data]) async throws -> SendChatQuery {
        var sendChatModel = SendChatQuery(content: message.content ?? "", files: [])
        
        if !imageDataList.isEmpty {
            let postImageQuery = PostImageQuery(imageData: imageDataList)
            let fileUpload = try await NetworkManager2.shared.performRequest(
                router: .sendFiles(message.roomID, postImageQuery),
                responseType: PostImageModel.self
            )
            sendChatModel.files = fileUpload.files
        }
        
        return sendChatModel
    }
}
