//
//  AppleLogin.swift
//  SpotChat
//
//  Created by 최대성 on 10/31/24.
//

import UIKit
import AuthenticationServices

extension AuthVC: ASAuthorizationControllerDelegate {
    
    // 인증 실패시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print("로그인 실패")
    }
}

extension AuthVC: ASAuthorizationControllerPresentationContextProviding {
    
    
    func handleAppleSignIn() {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        
        
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
    }
    
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window ?? UIWindow()
    }
    
    // 사용자 인증 후 처리
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
            print("전체 이름: \(fullName?.givenName ?? "")\(fullName?.familyName ?? "")")
            print("이메일: \(email ?? "")")
            print("Token: \(identityToken!)")
            let idToken = String(data: identityToken!, encoding: .utf8)!
            print("authorizationCode: \(authorizationCode!)")
            //eotjd0818@naver.com
            //대성 최
            UserDefaultManager.appleLoginUserId = userIdentifier
            print("idToken", idToken)
            UserDefaultManager.userNickname = fullName?.givenName ?? "" + (fullName?.familyName ?? "")
            
            let applLoginQuery = AppleLgoinQuery(idToken: idToken, nick: UserDefaultManager.userNickname)
            print("여기는 아이디 관련?")
            NetworkManager.shared.performRequest(router: .appleLogin(query: applLoginQuery), responseType: AuthModel.self) { result in
                print("결과 가져와서~")
                switch result {
                case .success(let success):
                    print(success)
                case .failure(let failure):
                    print(failure)
                }
            }
//            
            
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            
            let vc = UINavigationController(rootViewController: TabBarVC())
            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
            
           
        case let passwordCredential as ASPasswordCredential:
            let userIdentifier = passwordCredential.user
            let password = passwordCredential.password
            
            print("🔫🔫🔫🔫패스워드🔫🔫🔫🔫")
            print("사용자: \(userIdentifier)")
            print("비밀번호: \(password)")
            
//            UserDefaultManager.appleLoginUserId = userIdentifier
//            
//            let applLoginQuery = AppleLgoinQuery(idToken: "eotjd0818@naver.com", nick: "킷캣")
//            print("여기는?")
//            NetworkManager.shared.performRequest(router: .appleLogin(query: applLoginQuery), responseType: AuthModel.self) { result in
//                print("결과 가져와서~")
//                switch result {
//                case .success(let success):
//                    print(success)
//                case .failure(let failure):
//                    print(failure)
//                }
//            }
            
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            
            let vc = UINavigationController(rootViewController: MapVC())
            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
            
            
        default: break
            
        }
    }
}
