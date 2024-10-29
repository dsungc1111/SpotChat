//
//  AuthVC.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices

final class AuthVC: BaseVC {
    
    private let authView = AuthView()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func bind() {
        
        authView.emailLoginBtn.rx.tap
            .bind(with: self) { owner, _ in
                print("fdfdfd")
                let vc = SignUpVC()
                vc.sheetPresentationController?.prefersGrabberVisible = true
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        authView.signinBtn.rx.tap
            .bind(with: self) { owner, _ in
                print("fdfdfd")
                let vc = SignUpVC()
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        authView.appleLoginBtn.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(with: self) { owner, _ in
                owner.handleAppleSignIn()
            }
            .disposed(by: disposeBag)
    }
    
    private func handleAppleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let requset = provider.createRequest()
        
        
        requset.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [requset])
        
        controller.delegate = self
        
        controller.presentationContextProvider = self
        
        controller.performRequests()

    }
    
    
}


extension AuthVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window ?? UIWindow()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print("로그인 실패")
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
           switch authorization.credential {
               
           case let appleIdCredential as ASAuthorizationAppleIDCredential:
               let userIdentifier = appleIdCredential.user
               let fullName = appleIdCredential.fullName
               let email = appleIdCredential.email
               
               let identityToken = appleIdCredential.identityToken
               let authorizationCode = appleIdCredential.authorizationCode
               
               print("Apple ID 로그인에 성공하였습니다.")
               print("사용자 ID: \(userIdentifier)")
               print("전체 이름: \(fullName?.givenName ?? "") \(fullName?.familyName ?? "")")
               print("이메일: \(email ?? "")")
               print("Token: \(identityToken!)")
               print("authorizationCode: \(authorizationCode!)")
               
               // 여기에 로그인 성공 후 수행할 작업을 추가하세요.
//               let mainVC = MainViewController()
//               mainVC.modalPresentationStyle = .fullScreen
//               present(mainVC, animated: true)
               
           // 암호 기반 인증에 성공한 경우(iCloud), 사용자의 인증 정보를 확인하고 필요한 작업을 수행합니다
           case let passwordCredential as ASPasswordCredential:
               let userIdentifier = passwordCredential.user
               let password = passwordCredential.password
               
               print("암호 기반 인증에 성공하였습니다.")
               print("사용자 이름: \(userIdentifier)")
               print("비밀번호: \(password)")
               
               // 여기에 로그인 성공 후 수행할 작업을 추가하세요.
//               let mainVC = MainViewController()
//               mainVC.modalPresentationStyle = .fullScreen
//               present(mainVC, animated: true)
//               
           default: break
               
           }
       }
}
