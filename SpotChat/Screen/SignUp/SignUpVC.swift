//
//  SignUpVC.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit
import Combine
import CombineCocoa

final class SignUpVC: BaseVC {
    
    private let signUpView = SignUpView()
    
    private let signupVM = SignUpVM()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = signUpView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let input = signupVM.input
        
        let output = signupVM.transform(input: input)
        
        // 사용자가 텍스트필드에 입력을 했을 때 UI변경 X > Runloop.main
        // UI변경 0 > Dispatchqueue.main
        signUpView.emailTextField.textPublisher
            .map { $0 ?? "" }
            .subscribe(input.emailText)
            .store(in: &cancellables)
        
        signUpView.passwordTextField.textPublisher
            .map { $0 ?? "" }
            .subscribe(input.passwordText)
            .store(in: &cancellables)
        
        signUpView.passwordCheckTextField.textPublisher
            .map { $0 ?? "" }
            .subscribe(input.passwordCheck)
            .store(in: &cancellables)
        
        signUpView.nicknameTextField.textPublisher
            .map { $0 ?? "" }
            .subscribe(input.nicknameText)
            .store(in: &cancellables)
        
        signUpView.phoneNumberTextfield.textPublisher
            .map { $0 ?? "" }
            .subscribe(input.phoneNumberText)
            .store(in: &cancellables)
        
        signUpView.emailValidBtn.tapPublisher
            .subscribe(input.emailValidTap)
            .store(in: &cancellables)
        
        signUpView.signInBtn.tapPublisher
            .subscribe(input.signInTap)
            .store(in: &cancellables)
        
        
        output.emailValidation
            .sink { text in
                print("이메일 유효성 검사", text)
            }
            .store(in: &cancellables)
        
        output.singUpValidation
            .sink { text in
                print("회원가입 확인", text)
            }
            .store(in: &cancellables)
        
        
    }
    
}
