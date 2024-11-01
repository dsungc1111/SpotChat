//
//  KakaoAuthVM.swift
//  SpotChat
//
//  Created by 최대성 on 10/31/24.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

final class KakaoAuthVM: ObservableObject {
    
    var cancellables = Set<AnyCancellable>()
    
    @Published var isLoggedIn: Bool = false
    
    init() {
        print("gogo")
    }
    
    // UI와 관련된 isLoggedIn > MainActor로 메인스레드에서 작동하게
    @MainActor
    func kakaoSignIn() {
        Task {
            if UserApi.isKakaoTalkLoginAvailable() {
                isLoggedIn = await kakaoSignInWithApp()
            } else {
                isLoggedIn = await kakaoSignInWithAccount()
            }
        }
    }
    @MainActor
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() { self.isLoggedIn = false }
        }
    }

    
    
    // 카카오 앱 로그인
    @MainActor
    func kakaoSignInWithApp() async -> Bool {
        
        await withCheckedContinuation { continuation in
            
            print("🔫🔫🔫앱로그인")
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                
                if let error = error { print(error); continuation.resume(returning: false) }
                else {
                    UserDefaultManager.kakaoToken = oauthToken!.accessToken
                    continuation.resume(returning: true)
                    let kakao = KakaoLoginQuery(oauthToken: UserDefaultManager.kakaoToken)
                    print("카카오 쿼리 받아서 넘겨줄거야")
                    NetworkManager.shared.performRequest(router: .kakaoLogin(query: kakao), responseType: AuthModel.self) { result in
                        switch result {
                        case .success(let success):
                            print("성공" , success)
                        case .failure(let failure):
                            print("tㅣㄹㅇㄴㄹ" , failure)
                        }
                    }
                    
                }
            }
        }
    }
    
    // 카카오 계정으로 로그인
    func kakaoSignInWithAccount() async -> Bool {
        
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error { print(error); continuation.resume(returning: false) }
                else {
                    UserDefaultManager.kakaoToken = oauthToken!.accessToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
     
    func handleKakaoLogout() async -> Bool {
        
        await withCheckedContinuation { continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }

        }
        
    }
}
