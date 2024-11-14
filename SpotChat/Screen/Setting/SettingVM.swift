//
//  SettingVM.swift
//  SpotChat
//
//  Created by 최대성 on 11/14/24.
//

import Foundation
import Combine

final class SettingVM: BaseVMProtocol {
    
    var cancellables: Set<AnyCancellable> = []
    
    
    struct Input {
        let trigger: PassthroughSubject<String, Never>
    }
    
    struct Output {
        let myInfoList: PassthroughSubject<ProfileModel, Never>
    }
    
    
    func transform(input: Input) -> Output {
        
        let myInfoList = PassthroughSubject<ProfileModel, Never>()
        
        input.trigger
            .flatMap{ value in
                // combine의 Future(퍼블리셔)를 사용하여
                // 하나의 값 or 에러를 방출
                Future<ProfileModel, Error> { promise in
                    Task {
                        do {
                            let result = try await NetworkManager2.shared.performRequest(router: .myProfile, responseType: ProfileModel.self)
                            
                            promise(.success(result))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
            }
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    print("😈😈😈😈 finished")
                case .failure(let failure):
                    print("실패", failure)
                    print("😈😈😈😈 실패 = ", failure)
                }
            }, receiveValue: { profileModel in
                
                print(profileModel)
                myInfoList.send(profileModel)
                
                
            })
            .store(in: &cancellables)
        
        
        
        
        return Output(myInfoList: myInfoList)
    }
    
}
