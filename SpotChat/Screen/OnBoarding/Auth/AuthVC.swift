//
//  AuthVC.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit
import Combine
import CombineCocoa
import KakaoSDKAuth
import KakaoSDKUser

final class AuthVC: BaseVC {
    
    private let authView = AuthView()
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var kakaoAuthVM = KakaoAuthVM()
    
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
        
        authView.kakaoLoginBtn.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                kakaoAuthVM.kakaoSignIn()
            }
            .store(in: &cancellables)
        
        
        authView.emailLoginBtn.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                kakaoAuthVM.kakaoLogout()
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
}
