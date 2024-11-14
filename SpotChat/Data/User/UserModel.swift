//
//  UserResponseModel.swift
//  SpotChat
//
//  Created by 최대성 on 11/5/24.
//

import Foundation


struct EmailValidationModel: Codable {
    let message: String
}
// 로그인, 회원가입 모델
struct AuthModel: Codable {
    let user_id: String
    let email: String
    let nick: String
    let accessToken: String
    let refreshToken: String
}

// 애플 로그인 응답 모델
struct AppleLoginModel: Codable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
}


struct TokenModel: Codable {
    
    let accessToken: String
    let refreshToken: String
}


struct ProfileModel: Codable {
    let userID, email, nick, profileImage: String?
    let phoneNum, gender, birthDay, info1: String
    let info2, info3, info4, info5: String
    let followers, following: [Follow]
    let posts: [String]

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nick, profileImage, phoneNum, gender, birthDay, info1, info2, info3, info4, info5, followers, following, posts
    }
}

// MARK: - Follow
struct Follow: Codable {
    let userID, nick, profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick, profileImage
    }
}
