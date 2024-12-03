//
//  ChatHistory.swift
//  SpotChat
//
//  Created by 최대성 on 11/27/24.
//

import Foundation
import RealmSwift


final class UserInfo: Object {
    @Persisted(primaryKey: true) var userID: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
}

final class ChatMessage: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var chatID: String
    @Persisted(indexed: true) var createdAt: String
    @Persisted var sender: UserInfo? // 메시지 작성자 ⭐️⭐️⭐️⭐️⭐️(참조)
    @Persisted var content: String
    @Persisted var files: List<String>
}
