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
    
    private var cancellables = Set<AnyCancellable>()
    
    
    override func loadView() {
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
    }
    
    override func bind() {
        
        var emailText = ""
        var passwordText = ""
        
        
        signInView.emailTextField.textPublisher // 텍스트가 변할때마다
            .compactMap { $0 } // 옵셔널 처리한 text를
            .sink(receiveValue: { text in
                emailText = text
            }) // input.emailText에 넣어줄래요~
            .store(in: &cancellables) // 구독했으니 스트림 끊어줄래요~ 메모리 누수 방지요~
        
        signInView.passwordTextField.textPublisher
            .compactMap { $0 }
            .sink(receiveValue: { text in
                passwordText = text
            })
            .store(in: &cancellables)
        
        
        
        signInView.signInBtn.tapPublisher
            .sink { _ in
                let loginQuery = LoginQuery(email: emailText, password: passwordText)
                NetworkManager.shared.performRequest(router: .login(query: loginQuery), responseType: AuthModel.self) { result in
                    
                    switch result {
                    case .success(let success):
                        print("성공", success)
                        UserDefaultManager.accessToken = success.accessToken
                        UserDefaultManager.refreshToken = success.refreshToken
                        UserDefaultManager.userId = success.user_id
                        UserDefaultManager.userNickname = success.nick
                        UserDefaultManager.userEmail = success.email
                        
                        DispatchQueue.main.async {
                            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                            
                            let sceneDelegate = windowScene?.delegate as? SceneDelegate
                            
                            
                            let vc = UINavigationController(rootViewController: TabBarVC())
                            
                            vc.navigationBar.tintColor = .black
                            sceneDelegate?.window?.rootViewController = vc
                            sceneDelegate?.window?.makeKeyAndVisible()
                        }
                      
                        
                    case .failure(let failure):
                        print("실패", failure)
                    }
                }
            }
            .store(in: &cancellables)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
}
