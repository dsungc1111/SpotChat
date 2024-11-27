//
//  ChatHistory.swift
//  SpotChat
//
//  Created by 최대성 on 11/27/24.
//

import Foundation
import RealmSwift


final class ChatHistoryTable: Object {
    @Persisted(primaryKey: true) var chatID: String
    @Persisted var roomID: String
    @Persisted var content: String
    @Persisted var createdAt: String
    @Persisted var files: List<String>
    @Persisted var sender: SenderTable?
}

final class SenderTable: Object, Codable {
    @Persisted(primaryKey: true) var userID: String
    @Persisted var email: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
}
