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
    
    
    struct Input {
        let trigger = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        let chatList: PassthroughSubject<[LastChat], Never>
    }
    
    @Published
    var input = Input()
    
    func transform(input: Input) -> Output {
        
        
        
        let chatList = PassthroughSubject<[LastChat], Never>()
        
        input.trigger
            .sink { roomID in
                Task {
                    let result = try await NetworkManager2.shared.performRequest(router: .getChatContent(roomID, nil), responseType: GetChattingContentModel.self)
                    
                    chatList.send(result.data)
                }
            }
            .store(in: &cancellables)
        
        
        return Output(chatList: chatList)
        
    }
    
}
