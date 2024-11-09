//
//  SignInVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/1/24.
//

import UIKit
import Combine
import CombineCocoa

final class SignInVC: BaseVC {
    
    private let signInView = SignInView()
    private let signInVM = SignInVM()
    
    private var cancellables = Set<AnyCancellable>()
    
    
    override func loadView() {
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
    }
    
    override func bind() {
        
        let input = SignInVM.Input(
            emailText: PassthroughSubject<String, Never>(),
            passwordText: PassthroughSubject<String, Never>(),
            signInBtnTap: PassthroughSubject<Void, Never>()
        )
        let output = signInVM.transform(input: input)
        
        signInView.emailTextField.textPublisher
            .compactMap{ $0 }
            .subscribe(input.emailText)
            .store(in: &cancellables)
        
        signInView.passwordTextField.textPublisher
            .compactMap{ $0 }
            .subscribe(input.passwordText)
            .store(in: &cancellables)
        
        signInView.signInBtn.tapPublisher
            .map { _ in } // 버튼 탭 시 Void 값을 넘김
            .subscribe(input.signInBtnTap)
            .store(in: &cancellables)
        
        
        output.loginSuccess
            .sink { _ in
                
                DispatchQueue.main.async {
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    
                    let vc = TabBarVC()
                    sceneDelegate?.window?.rootViewController = vc
                    sceneDelegate?.window?.makeKeyAndVisible()
                }
             
                
            }
            .store(in: &cancellables)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
}
