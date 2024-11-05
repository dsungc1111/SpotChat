//
//  SignInVM.swift
//  SpotChat
//
//  Created by 최대성 on 11/5/24.
//

import Foundation
import Combine


final class SignInVM: BaseVMProtocol {
    
    
    struct Input {
        let emailText: PassthroughSubject<String, Never>
        let passwordText: PassthroughSubject<String, Never>
        let signInBtnTap: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let loginSuccess: PassthroughSubject<Void, Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    private var emailText = ""
    private var passwordText = ""
    
    
    
    func transform(input: Input) -> Output {
        
        
        let loginSuccess = PassthroughSubject<Void, Never>()
        
        input.emailText
            .assign(to: \.emailText, on: self)
            .store(in: &cancellables)
        
        input.passwordText
            .assign(to: \.passwordText, on: self)
            .store(in: &cancellables)
        
        
        input.signInBtnTap
            .map { [weak self] _ in
                guard let self else { return LoginQuery(email: "", password: "")}
                let loginQuery = LoginQuery(email: emailText, password: passwordText)
                
                return loginQuery
            }
            .sink { loginQuery in
                
                NetworkManager.shared.performRequest(router: .login(query: loginQuery), responseType: AuthModel.self) { result in
                    
                    switch result {
                    case .success(let success):
                        
                        print("로그인 성공", success)
                        UserDefaultManager.accessToken = success.accessToken
                        UserDefaultManager.refreshToken = success.refreshToken
                        UserDefaultManager.userId = success.user_id
                        UserDefaultManager.userNickname = success.nick
                        UserDefaultManager.userEmail = success.email
                        
                        loginSuccess.send()
                        
                    case .failure(let failure):
                        print("실패", failure)
                    }
                }
            }
            .store(in: &cancellables)
        
        
        
        return Output(loginSuccess: loginSuccess)
    }
}
