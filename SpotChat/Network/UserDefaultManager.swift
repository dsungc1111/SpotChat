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
        case userId
        case profile
    }
    
    
    static let shared = UserDefaultManager()
    
    private init() {}
    
    @UserDefault(key: UserDefaultKey.access.rawValue, defaultValue: "")
    static var accessToken
    
    @UserDefault(key: UserDefaultKey.refresh.rawValue, defaultValue: "")
    static var refreshToken
    
    @UserDefault(key: UserDefaultKey.userNickname.rawValue, defaultValue: "")
    static var userNickname
    
    @UserDefault(key: UserDefaultKey.userId.rawValue, defaultValue: "")
    static var userId
    
    @UserDefault(key: UserDefaultKey.profile.rawValue, defaultValue: "")
    static var profileImage
}
