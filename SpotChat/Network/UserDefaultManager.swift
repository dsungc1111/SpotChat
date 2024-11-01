//
//  UserDefaultManager.swift
//  SpotChat
//
//  Created by 최대성 on 10/28/24.
//

import Foundation


@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.string(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

final class UserDefaultManager {
    
    private enum UserDefaultKey: String {
        case access
        case refresh
        case userNickname
        case userEmail
        case userId
        case profile
        case appleLoginUserId
        case kakaoToken
    }
    
    
    static let shared = UserDefaultManager()
    
    private init() {}
    
    @UserDefault(key: UserDefaultKey.access.rawValue, defaultValue: "")
    static var accessToken
    
    @UserDefault(key: UserDefaultKey.refresh.rawValue, defaultValue: "")
    static var refreshToken
    
    @UserDefault(key: UserDefaultKey.userNickname.rawValue, defaultValue: "")
    static var userNickname
    
    // 애플, 이메일, 카카오 토큰 넣자
    @UserDefault(key: UserDefaultKey.userId.rawValue, defaultValue: "")
    static var userId
    
    @UserDefault(key: UserDefaultKey.profile.rawValue, defaultValue: "")
    static var profileImage
    
    
//    @UserDefault(key: UserDefaultKey.appleLoginUserId.rawValue, defaultValue: "")
//    static var appleLoginUserId
    
//    @UserDefault(key: UserDefaultKey.kakaoToken.rawValue, defaultValue: "")
//    static var kakaoToken
    
    @UserDefault(key: UserDefaultKey.userEmail.rawValue, defaultValue: "")
    static var userEmail
    
}
