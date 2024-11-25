//
//  ChatModel.swift
//  SpotChat
//
//  Created by 최대성 on 11/24/24.
//

import Foundation



struct ChattingList: Decodable {
    let data: [OpenChatModel]
}


struct OpenChatModel: Decodable, Hashable {
    let id: UUID = UUID()
    let roomID, createdAt, updatedAt: String
    let participants: [Sender]
    let lastChat: LastChat?

    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case createdAt, updatedAt, participants, lastChat
    }
}

// MARK: - LastChat
struct LastChat: Decodable, Hashable {
    let chatID, roomID, content: String
    let sender: Sender
    let files: [String]

    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case roomID = "room_id"
        case content, sender, files
    }
}

// MARK: - Sender
struct Sender: Decodable, Hashable {
    let userID, nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick, profileImage
    }
}

struct GetChattingContentModel: Decodable {
    let data: [LastChat]
}

