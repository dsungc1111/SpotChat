//
//  ChatListVM.swift
//  SpotChat
//
//  Created by 최대성 on 11/25/24.
//

import Foundation
import Combine

final class ChatListVM: BaseVMProtocol {
    
    
    
    struct Input {
        let trigger = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let chattingList: PassthroughSubject<[OpenChatModel], Never>
    }
        
    @Published
    var input = Input()
    
    var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        
        let chattingList = PassthroughSubject<[OpenChatModel], Never>()
        
        
        input.trigger
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    let result = await self.getChattingList()
                    chattingList.send(result)
                }
            }
            .store(in: &cancellables)
        
        return Output(chattingList: chattingList)
        
    }
}

extension ChatListVM {
    
    
    private func getChattingList() async -> [OpenChatModel] {
        
        
        do {
            let chattingList = try await NetworkManager2.shared.performRequest(router: .getChattingList, responseType: ChattingList.self)
            
            return chattingList.data
        } catch {
            print("채팅리스트 로드 실패")
            return []
        }
        
        
    }
    
}
