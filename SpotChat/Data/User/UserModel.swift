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
