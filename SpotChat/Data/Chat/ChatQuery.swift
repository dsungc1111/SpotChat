//
//  ChatQuery.swift
//  SpotChat
//
//  Created by 최대성 on 11/24/24.
//

import Foundation


struct ChatQuery: Encodable {
    let opponent_id: String
}
struct SendChatQuery: Encodable {
    let content: String
    let files: [String]
}
