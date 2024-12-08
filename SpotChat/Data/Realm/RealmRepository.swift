//
//  RealmRepository.swift
//  SpotChat
//
//  Created by 최대성 on 11/27/24.
//

import Foundation
import RealmSwift

final class RealmRepository {
    
    func fetchRealmURL() {
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    /// ChatRoom 확인 및 생성
    func fetchOrCreateChatRoom(roomID: String) -> ChatRoom? {
        do {
            let realm = try Realm()
            var chatRoom = realm.object(ofType: ChatRoom.self, forPrimaryKey: roomID)
            
            if chatRoom == nil {
                chatRoom = ChatRoom(value: ["roomID": roomID])
                try realm.write {
                    realm.add(chatRoom!)
                }
            }
            
            return chatRoom
        } catch let error {
            print("챗룸 확인 혹은 생성 실패:", error)
            return nil
        }
    }
    
    /// 읽지 않은 채팅 저장
    func saveUnreadChat(chat: [LastChat]) {
        guard !chat.isEmpty else { return }
        do {
            let realm = try Realm()
            let roomID = chat[0].roomID
            
            // ChatRoom 처리
            var chatRoom = realm.object(ofType: ChatRoom.self, forPrimaryKey: roomID)
            if chatRoom == nil {
                chatRoom = ChatRoom(value: ["roomID": roomID])
                try realm.write {
                    realm.add(chatRoom!)
                }
            }
            
            for item in chat {
                // Sender 처리
                var sender = realm.object(ofType: UserInfo.self, forPrimaryKey: item.sender.userID)
                if sender == nil {
                    sender = UserInfo(value: [
                        "userID": item.sender.userID,
                        "nickname": item.sender.nick,
                        "profileImage": item.sender.profileImage ?? ""
                    ])
                    try realm.write {
                        realm.add(sender!, update: .modified) // 중복 확인 후 업데이트
                    }
                } else {
                    try realm.write {
                        sender?.nickname = item.sender.nick
                        sender?.profileImage = item.sender.profileImage
                    }
                }
                
                // ChatMessage 처리
                if let existingMessage = realm.object(ofType: ChatMessage.self, forPrimaryKey: item.chatID) {
                    // 이미 존재하는 메시지 업데이트
                    try realm.write {
                        existingMessage.content = item.content ?? ""
                        existingMessage.createdAt = ""
                        existingMessage.sender = sender
                        existingMessage.files.removeAll()
                        existingMessage.files.append(objectsIn: item.files)
                    }
                } else {
                    // 새 메시지 추가
                    let chatMessage = ChatMessage(value: [
                        "chatID": item.chatID, // Primary Key
                        "createdAt": "",
                        "sender": sender!,
                        "content": item.content ?? "",
                        "files": item.files
                    ])
                    try realm.write {
                        realm.add(chatMessage)
                    }
                }
                
                // ChatRoom에 메시지 추가 (중복 방지)
                try realm.write {
                    if !chatRoom!.chatList.contains(where: { $0.chatID == item.chatID }) {
                        let chatMessage = realm.object(ofType: ChatMessage.self, forPrimaryKey: item.chatID)
                        if let chatMessage = chatMessage {
                            chatRoom!.chatList.append(chatMessage)
                            print("챗룸에 저장")
                        }
                    }
                }
            }
        } catch let error {
            print("최신 날짜 이후 채팅 저장 실패:", error)
        }
    }
    
    /// 최신 메시지의 createdAt 반환
    func fetchRecentDate(for roomID: String) -> String {
        do {
            let realm = try Realm()
            guard let chatRoom = realm.object(ofType: ChatRoom.self, forPrimaryKey: roomID) else {
                print("해당 RoomID에 대한 ChatRoom이 없습니다.")
                return ""
            }
            if let lastMessage = chatRoom.chatList.sorted(byKeyPath: "createdAt", ascending: false).first {
                return lastMessage.createdAt
            } else {
                return ""
            }
        } catch let error {
            print("최신 날짜 패치 실패:", error)
            return ""
        }
    }
    
    /// 저장된 메시지 20개 + 서버에서 전달받은 메시지 개수만큼 로드
    func fetchSavedChat(unread: Int, roomID: String) -> [ChatMessage] {
        do {
            let realm = try Realm()
            
            guard let chatRoom = realm.object(ofType: ChatRoom.self, forPrimaryKey: roomID) else {
                print("해당 RoomID에 대한 ChatRoom이 없습니다.")
                return []
            }
            
            let savedMessages = chatRoom.chatList
                .sorted(byKeyPath: "createdAt", ascending: true)
                .freeze()
                .suffix(20 + unread)
            
            return Array(savedMessages)
        } catch let error {
            print("저장된 정보 로드 실패:", error)
            return []
        }
    }
    
    /// 소켓 메시지 저장
    func saveChatMessage(chat: SocketDMModel) {
        
            do {
                let realm = try Realm()
                
                // Sender 정보 확인 및 저장
                var sender = realm.object(ofType: UserInfo.self, forPrimaryKey: chat.sender.userID)
                if sender == nil {
                    sender = UserInfo(value: [
                        "userID": chat.sender.userID,
                        "nickname": chat.sender.nick,
                        "profileImage": chat.sender.profileImage ?? ""
                    ])
                    try realm.write {
                        realm.add(sender!)
                    }
                }
                
                // ChatMessage 저장
                try realm.write {
                    let chatMessage = ChatMessage(value: [
                        "chatID": chat.chatID, // Primary Key
                        "createdAt": chat.createdAt,
                        "sender": sender!,
                        "content": chat.content ?? "",
                        "files": chat.files
                    ])
                    realm.add(chatMessage, update: .modified)
                }
                
                // ChatRoom 확인 및 연결
                var chatRoom = realm.object(ofType: ChatRoom.self, forPrimaryKey: chat.roomID)
                if chatRoom == nil {
                    chatRoom = ChatRoom(value: ["roomID": chat.roomID])
                    try realm.write {
                        realm.add(chatRoom!)
                    }
                }
                
                // ChatRoom 업데이트
                try realm.write {
                    if !chatRoom!.userList.contains(sender!) {
                        chatRoom!.userList.append(sender!)
                    }
                    if !chatRoom!.chatList.contains(where: { $0.chatID == chat.chatID }) {
                        let chatMessage = realm.object(ofType: ChatMessage.self, forPrimaryKey: chat.chatID)
                        if let chatMessage = chatMessage {
                            chatRoom!.chatList.append(chatMessage)
                        }
                    }
                }
                
                // ChatRoom과 메시지를 freeze하여 UI에서 안전하게 사용
                let frozenChatRoom = chatRoom?.freeze()
                let frozenChatMessages = frozenChatRoom?.chatList.freeze()
                
                print("🔵 UI 업데이트:", frozenChatMessages ?? [])
                
                
                print("👽 저장 완료")
            } catch let error {
                print("소켓 메시지 저장 실패:", error)
            }
        
    }
    
    /// 최신 메시지 로드
    func fetchLatestChat() -> [ChatMessage] {
        do {
            let realm = try Realm()
            return Array(realm.objects(ChatMessage.self).sorted(byKeyPath: "createdAt", ascending: false).freeze())
        } catch {
            print("최신 메시지 로드 실패")
            return []
        }
    }
    
    
    
    // for 페이지네이션
    func fetchChats(roomID: String, offset: Int, limit: Int) -> [ChatMessage] {
          do {
              let realm = try Realm()
              guard let chatRoom = realm.object(ofType: ChatRoom.self, forPrimaryKey: roomID) else {
                  print("ChatRoom not found for ID: \(roomID)")
                  return []
              }
              
              let chats = chatRoom.chatList
                  .sorted(byKeyPath: "createdAt", ascending: false)
                  .dropFirst(offset)
                  .prefix(limit)
              
              return Array(chats)
          } catch {
              print("Failed to fetch chats: \(error)")
              return []
          }
      }
}
