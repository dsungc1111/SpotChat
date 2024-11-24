//
//  SearchVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/24/24.
//

import UIKit


final class SearchVC: BaseVC {
    
    var resultList: [Follow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
            print("👉👉👉👉👉👉👉",resultList)
        
        Task {
            
            let open = ChatQuery(opponent_id: "6742ff763a36e82f5332a5dc")
            
            let result = try await NetworkManager2.shared.performRequest(router: .openChattingRoom(query: open), responseType: OpenChatModel.self)
            
            print("👍👍👍👍👍👍👍👍👍", result)
            
            print("==================================================")
            
            let result2 = try await NetworkManager2.shared.performRequest(router: .getChattingList, responseType: ChattingList.self)
            
            print("🟣🟣🟣🟣🟣🟣🟣🟣🟣", result2)
            
            let roomId = result2.data[0].roomID
            
            let query = SendChatQuery(content: "집에가자 제발", files: [])
            
            let result3 = try await NetworkManager2.shared.performRequest(router: .sendChat(roomId, query), responseType: LastChat.self)
            
            print("🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴", result3)
            
            let result4 = try await NetworkManager2.shared.performRequest(router: .getChatContent(roomId, nil), responseType: GetChattingContentModel.self)
            
            print("🟤🟤🟤🟤🟤🟤🟤🟤🟤", result4)
            
        }
        
        
    }
    
}
