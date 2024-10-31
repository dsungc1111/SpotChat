//
//  SignUpVM.swift
//  SpotChat
//
//  Created by 최대성 on 10/31/24.
//

import Foundation
import Combine
import CombineCocoa


final class SignUpVM {
    
    
    struct Input {
        let emailText: PassthroughSubject<String, Never>
        let passwordText: PassthroughSubject<String, Never>
        let emailValidTap: PassthroughSubject<Void, Never>
        let passwordCheck: PassthroughSubject<String, Never>
        let nicknameText: PassthroughSubject<String, Never>
        let phoneNumberText: PassthroughSubject<String, Never>
        let signInTap: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let emailText: PassthroughSubject<String, Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    private var emailText = ""
    private var passwordText = ""
    private var nicknameText = ""
    private var phoneText = ""
    
    
    func transform(input: Input) {
        
        
        input.emailText
            .assign(to: \.emailText, on: self)
            .store(in: &cancellables)
        input.passwordText
            .assign(to: \.passwordText, on: self)
            .store(in: &cancellables)
        input.nicknameText
            .assign(to: \.nicknameText, on: self)
            .store(in: &cancellables)
        input.phoneNumberText
            .assign(to: \.phoneText, on: self)
            .store(in: &cancellables)
        
        
        input.emailValidTap
            .sink { [weak self] _ in
                guard let self else { return }
                
                print("중복확인 버튼", emailText )
                let emailValid = EmailValidationQuery(email: emailText)
                
                NetworkManager.shared.performRequest(
                    router: .emailValidation(query: emailValid),
                    responseType: EmailValidationModel.self) { result in
                    switch result {
                    case .success(let success):
                        print("성공띠", success)
                    case .failure(let failure):
                        print("실패에요", failure)
                    }
                }
            }
            .store(in: &cancellables)
        
        input.passwordCheck
            .sink { [weak self] password in
                print("패스워드 텍스트 체크")
                guard let self else { return }
                if passwordText == password {
                    print("😁😁😁똑같넹")
                } else {
                    print("😠😠😠다르넹")
                }
            }
            .store(in: &cancellables)
        
        input.signInTap
            .sink { [weak self] _ in
                guard let self else { return }
                let signInText = SigninQuery(email: emailText, password: passwordText, nick: nicknameText, phoneNum: phoneText, birthDay: "", gender: "", info1: "", info2: "", info3: "", info4: "", info5: "")
                
                NetworkManager.shared.performRequest(router: .signin(query: signInText), responseType: AuthModel.self) { result in
                    switch result {
                    case .success(let success):
                        print("성공, ", success)
                    case .failure(let failure):
                        print("실패, ", failure)
                    }
                }
            }
            .store(in: &cancellables)
        
       
    }
}


