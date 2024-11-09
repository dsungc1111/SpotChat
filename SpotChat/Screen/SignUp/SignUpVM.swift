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
        let emailText = CurrentValueSubject<String, Never>("")
        let passwordText = CurrentValueSubject<String, Never>("")
        let emailValidTap = PassthroughSubject<Void, Never>()
        let passwordCheck = CurrentValueSubject<String, Never>("")
        let nicknameText = CurrentValueSubject<String, Never>("")
        let phoneNumberText = CurrentValueSubject<String, Never>("")
        let signInTap = PassthroughSubject<Void, Never>()

    }
    
    
    struct Output {
//        let emailText = CurrentValueSubject<String, Never>("")
//        var nicknameText = CurrentValueSubject<String, Never>("")
//        var passwordText = CurrentValueSubject<String, Never>("")
        
        let emailInvalid = PassthroughSubject<String, Never>()
        let singUpInvalid = PassthroughSubject<String, Never>()
    }
    
    @Published
    var input = Input()
    var output = Output()
    
    var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) {
        
        // 이메일, 비밀번호, 비밀번호 확인, 닉네임, 전화번호 합쳐서 fill로 버튼 색 변경
    
        
        
        input.emailText
            .sink { text in
                print("이메일 = ", text)
            }
            .store(in: &cancellables)
        
        input.passwordText
            .sink { text in
                print("패스워드 = ", text)
            }
            .store(in: &cancellables)
        
        input.phoneNumberText
            .sink { text in
                print("폰넘버 = ", text)
            }
            .store(in: &cancellables)
        
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
                    case .failure(let failure):
                        print("실패에요", failure)
                    }
                }
            }
            .store(in: &cancellables)
        
        input.passwordCheck
            .sink { password in
                print("패스워드 텍스트 체크")
                if input.passwordText.value == password {
                    print("😁😁😁똑같넹")
                } else {
                    print("😠😠😠다르넹")
                }
            }
            .store(in: &cancellables)
        
        input.signInTap
            .sink { _ in
                
                let signInText = SigninQuery(
                    email: input.emailText.value,
                    password: input.passwordText.value,
                    nick: input.nicknameText.value,
                    phoneNum: input.phoneNumberText.value,
                    birthDay: "", gender: "",
                    info1: "", info2: "", info3: "",
                    info4: "", info5: "")
                
                NetworkManager.shared.performRequest(router: .signin(query: signInText), responseType: AuthModel.self) { result in
                    switch result {
                    case .success(let success):
                        print("👉👉성공 = ", success)
                    case .failure(let failure):
                        print("👉👉실패 = ", failure)
                    }
                }
            }
            .store(in: &cancellables)
        
       
    }
}


