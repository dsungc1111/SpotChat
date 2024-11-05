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
        
        // input에 어떤 값을 넣을지 정의
        let input = SignUpVM.Input(
            emailText: PassthroughSubject<String, Never>(),
            passwordText: PassthroughSubject<String, Never>(), 
            emailValidTap: PassthroughSubject<Void, Never>(), 
            passwordCheck: PassthroughSubject<String, Never>(),
            nicknameText: PassthroughSubject<String, Never>(), 
            phoneNumberText: PassthroughSubject<String, Never>(), 
            signInTap: PassthroughSubject<Void, Never>()
        )
        
        // 텍스트필드 text 바뀔때마다 Input.emailtext, passwordText 에 바인딩
        signUpView.emailTextField.textPublisher // 텍스트가 변할때마다
            .compactMap { $0 } // 옵셔널 처리한 text를
            .subscribe(input.emailText) // input.emailText에 넣어줄래요~
            .store(in: &cancellables) // 구독했으니 스트림 끊어줄래요~ 메모리 누수 방지요~
        
        signUpView.passwordTextField.textPublisher
            .compactMap { $0 }
            .subscribe(input.passwordText)
            .store(in: &cancellables)
        
        signUpView.emailValidBtn.tapPublisher
            .subscribe(input.emailValidTap)
            .store(in: &cancellables)
        
        signUpView.passwordCheckTextField.textPublisher
            .compactMap { $0 }
            .subscribe(input.passwordCheck)
            .store(in: &cancellables)
        
        signUpView.nicknameTextField.textPublisher
            .compactMap { $0 }
            .subscribe(input.nicknameText)
            .store(in: &cancellables)
        
        signUpView.phoneNumberTextfield.textPublisher
            .compactMap { $0 }
            .subscribe(input.phoneNumberText)
            .store(in: &cancellables)
        
        signUpView.signInBtn.tapPublisher
            .subscribe(input.signInTap)
            .store(in: &cancellables)
            
        // 바인딩한 값을 메서드에 대입 후 실행
        signupVM.transform(input: input)
        
        
        
        
    }
    
}
