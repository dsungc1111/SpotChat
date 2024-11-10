//
//  SignUpVM.swift
//  SpotChat
//
//  Created by 최대성 on 10/31/24.
//

import Foundation
import Combine
//import CombineCocoa

final class SignUpVM {
    
    
    struct Input {
        
        let emailText = CurrentValueSubject<String, Never>("")
        let passwordText = CurrentValueSubject<String, Never>("")
        let emailValidTap = PassthroughSubject<Void, Never>()
        let passwordCheck = CurrentValueSubject<String, Never>("")
        let nicknameText = CurrentValueSubject<String, Never>("")
        let phoneNumberText = CurrentValueSubject<String, Never>("")
        let signInTap = PassthroughSubject<Void, Never>()

    }
    
    struct Output {
        
        let emailValidation: PassthroughSubject<String, Never>
        let singUpValidation: PassthroughSubject<String, Never>
        
    }
    
    @Published
    var input = Input()
    
    var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        
        let emailValidation = PassthroughSubject<String, Never>()
        let signUpValidation = PassthroughSubject<String, Never>()
        
        // 이메일 중복 검사
        input.emailValidTap
            .map { _ in
                let emailValid = EmailValidationQuery(email: input.emailText.value)
                return emailValid
            }
            .sink { emailQuery in
                
                NetworkManager.shared.performRequest(
                    router: .emailValidation(query: emailQuery),
                    responseType: EmailValidationModel.self) { result in
                    switch result {
                    case .success(let success):
                        print("성공띠", success)
                        emailValidation.send(success.message)
                    case .failure(let failure):
                        print("실패에요", failure)
                    }
                }
            }
            .store(in: &cancellables)
        
        input.signInTap
            .map { _ in
                let signInText = SigninQuery(
                    email: input.emailText.value,
                    password: input.passwordText.value,
                    nick: input.nicknameText.value,
                    phoneNum: input.phoneNumberText.value,
                    birthDay: "", gender: "",
                    info1: "", info2: "", info3: "",
                    info4: "", info5: "")
                
                return signInText
            }
            .sink { signInQuery in
                
                NetworkManager.shared.performRequest(router: .signin(query: signInQuery), responseType: AuthModel.self) { result in
                    switch result {
                    case .success(let success):
                        print("👉👉성공 = ", success)
                        signUpValidation.send(success.nick)
                    case .failure(let failure):
                        print("👉👉실패 = ", failure)
                    }
                }
            }
            .store(in: &cancellables)
        
        return Output(
            emailValidation: emailValidation,
            singUpValidation: signUpValidation
        )
    }
}


