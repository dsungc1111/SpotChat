//
//  SocketModel.swift
//  SpotChat
//
//  Created by 최대성 on 11/26/24.
//

import Foundation


struct SocketDMModel: Codable {
    let chatID: String
    let roomID: String
    let content: String
    let createdAt: String
    let files: [String]
    let sender: Sender
    
    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case roomID = "room_id"
        case content
        case createdAt
        case files
        case sender
    }
}


