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
        
        print( Realm.Configuration.defaultConfiguration.fileURL ?? "")
        
        
    }
    
    // 소켓으로 받아온 채팅 저장
    func saveChatMessage(chat: SocketDMModel) {
        do {
            
            let realm = try Realm()
            
            // 유저아이디가 프라이머리키인 userinfo 정보
            var sender = realm.object(ofType: UserInfo.self, forPrimaryKey: chat.sender.userID)
            print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥sender ==>>")
            // 없다면?
            if sender == nil {
                sender = UserInfo(value: [
                    "userID" : chat.sender.userID,
                    "nickname" : chat.sender.nick,
                    "profileImage" : chat.sender.profileImage ?? ""
                ])
                try realm.write {
                    realm.add(sender!)
                }
            }
            
            let chatMessage = ChatMessage()
            chatMessage.chatID = chat.chatID
            chatMessage.createdAt = chat.createdAt
            chatMessage.sender = sender
            chatMessage.files.append(objectsIn: chat.files)
            chatMessage.content = chat.content ?? ""
            
            try realm.write {
                realm.add(chatMessage)
            }
            
            print("👽 저장 완료")
            
            
        } catch let error {
            print("소켓에서 받아온 채팅 저장", error)
        }
        
    }
    
    // 최신 시간 이후 안 읽은 채팅 저장
    func saveUnreadChat(chat: [LastChat]) {
        if chat.count != 0 {
            do {
                let realm = try Realm()
                
                
                // 사용자 정보 가져오기
                let sender = realm.object(ofType: UserInfo.self, forPrimaryKey: chat[0].sender.userID)
                
                let myInfo = UserInfo()
                
                myInfo.nickname = UserDefaultsManager.userNickname
                myInfo.profileImage = UserDefaultsManager.profileImage
                myInfo.userID = UserDefaultsManager.userId
                
                // 메시지 생성
                let chatMessage = ChatMessage()
                chatMessage.sender = sender
                chatMessage.content = chat[0].content ?? ""
                chatMessage.createdAt = Date.formattedDate(for: Date(), format: "yyyy-MM-dd HH:mm:ss")
                chatMessage.files.append(objectsIn: chat[0].files)
                
                
            } catch let error {
                print("최신 날짜 이후 채팅 저장 실패", error)
            }
        }
    }
    
    // 최신날짜 전달
    func fetchRecentDate(for userID: String) -> String {
        do {
            let realm = try Realm()
            
            // ChatMessage에서 sender.userID를 기준으로 필터링
            let filteredMessages = realm.objects(ChatMessage.self)
                .filter("sender.userID == %@", userID)
            
            // 필터링된 메시지가 있으면 가장 최근 날짜 반환
            if let mostRecentMessage = filteredMessages.sorted(byKeyPath: "createdAt", ascending: false).first {
                return mostRecentMessage.createdAt
            } else {
                return "" // 필터 결과가 없는 경우 빈 문자열 반환
            }
        } catch {
            print("패치 에러:", error)
            return ""
        }
    }
    
    // 저장된 채팅 정보 20개 + @(안 읽었던 게 있다면) 전달
    func fetchSavedChat(unread: Int) -> [ChatMessage] {
        
        do {
            let realm = try Realm()
            
            // 최신 데이터 20개씩 가져다 씀
            let savedChat = realm.objects(ChatMessage.self)
                .sorted(byKeyPath: "createdAt", ascending: true)
                .freeze()
                .prefix(20)
            print("👉", savedChat)
            return Array(savedChat)
            
        } catch let error {
            print("저장된 정보 로드 에러", error)
            return []
        }
        
    }
    
    // 소켓에 저장한 내용 UI 바인드용 메서드 > 마지막 배열 하나 가져오면되지 않을까
    func fetchLatestChat() -> [ChatMessage] {
        
        do {
            let realm = try Realm()
            
            return Array(realm.objects(ChatMessage.self).sorted(byKeyPath: "createdAt", ascending: false))
            
        } catch {
            print("최신 내용 패치 실패")
            return []
        }
        
    }
    
}
