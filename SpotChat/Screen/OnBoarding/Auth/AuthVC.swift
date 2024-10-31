//
//  AuthVC.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit
import Combine
import CombineCocoa
import AuthenticationServices

final class AuthVC: BaseVC {
    
    private let authView = AuthView()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        // AuthenticationServices는 btn.tap XXX, Rxswift에서도 마찬가지
        // 따라서 로그인버튼에 제스처 인식을 추가해 탭을 인식할 때 combine을 통해 이벤트 처리
        let tapGesture = UITapGestureRecognizer()
        authView.appleLoginBtn.addGestureRecognizer(tapGesture)
        
        // tapPulisher를 이벤트 발생 시마다 publish되어, sink를 통해 이벤트 핸들러로 전달
        tapGesture.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                handleAppleSignIn()
            }
            .store(in: &cancellables)
        
        
        authView.emailLoginBtn.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                print("fdfdfd")
                let vc = SignUpVC()
                vc.sheetPresentationController?.prefersGrabberVisible = true
                present(vc, animated: true)
            }
            .store(in: &cancellables)
        
        authView.signinBtn.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                let vc = SignUpVC()
                present(vc, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func handleAppleSignIn() {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let requset = appleIDProvider.createRequest()
        
        
        requset.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [requset])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
    }
}
