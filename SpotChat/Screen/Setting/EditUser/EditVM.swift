//
//  EditVM.swift
//  SpotChat
//
//  Created by 최대성 on 11/22/24.
//

import Foundation
import Combine

struct ErrorResponse: Decodable {
    let message: String
}

final class EditVM: BaseVMProtocol {
    
    var cancellables = Set<AnyCancellable>()
    
    struct Input {
        let nicknameString = CurrentValueSubject<String, Never>("")
        let selectedImage = CurrentValueSubject<Data, Never>(Data())
        let editBtnTapped = PassthroughSubject<Void, Never>()
        let bioString = CurrentValueSubject<String, Never>("")
    }
    
    struct Output {
        
    }
    
    @Published
    var input = Input()
    
    func transform(input: Input) -> Output {
        
        input.bioString
            .sink { value in
                print(" value = ", value)
            }
            .store(in: &cancellables)
        
        
        input.editBtnTapped
            .map { _ in
                var editUserInfoQuery = EditUserQuery(
                    nick: input.nicknameString.value,
                    profile: input.selectedImage.value,
                    info1: input.bioString.value
                )
                return editUserInfoQuery
            }
            .sink { [weak self] editquery in
                print(input.selectedImage.value)
                guard let self = self else { return }
                print(editquery)
                Task {
                    await self.performEditUser(editquery)
                }
            }
            .store(in: &cancellables)
         
        
        return Output()
        
    }
    
    
    func performEditUser(_ editUserInfoQuery: EditUserQuery) async {
        
        do {
            let result = try await NetworkManager2.shared.performRequest(router: .editProfile(query: editUserInfoQuery), responseType: ProfileModel.self)
            
            
            print(result)
        } catch {
            print("dfd")
        }
        
    }
    
}
