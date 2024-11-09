//
//  SceneDelegate.swift
//  SpotChat
//
//  Created by 최대성 on 10/24/24.
//

import UIKit
import AuthenticationServices
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
            if let url = URLContexts.first?.url {
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
        }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        guard let scene  = (scene as? UIWindowScene) else { return }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: UserDefaultManager.userId) { [weak self] (credentialState, error) in
            
            guard let self else { return }
            
            switch credentialState {
                case .authorized:
                   print("authorized")
                   // The Apple ID credential is valid.
                   DispatchQueue.main.async {
                     //authorized된 상태이므로 바로 로그인 완료 화면으로 이동
                       self.window?.rootViewController = TabBarVC()
                       self.window?.makeKeyAndVisible()
                   }
                case .revoked:
                   print("애플 revoked")
                case .notFound:
                UserDefaultManager.userId = ""
                print("유저아이디", UserDefaultManager.accessToken)
                print("애플 notFound")
                DispatchQueue.main.async {
                    self.window = UIWindow(windowScene: scene)
                    if UserDefaultManager.userId.isEmpty {
                        
                        let vc = OnBoardingVC()
                        self.window?.rootViewController = UINavigationController(rootViewController: vc)
                        self.window?.makeKeyAndVisible()
                    } else {
                        let vc = TabBarVC()
                        self.window?.rootViewController = vc
                        self.window?.makeKeyAndVisible()
                    }
                }
            default:
                break
            }
        }
        
        
        
                
                
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

