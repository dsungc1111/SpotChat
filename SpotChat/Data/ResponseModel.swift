//
//  ResponseModel.swift
//  SpotChat
//
//  Created by 최대성 on 10/28/24.
//

import Foundation



struct EmailValidationQuery: Encodable {
    let email: String
}
struct SigninQuery: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String
    let birthDay: String
    let gender: String
    let info1: String
    let info2: String
    let info3: String
    let info4: String
    let info5: String
}
struct AppleLgoinQuery: Encodable {
    let idToken: String
    let nick: String
}
struct KakaoLoginQuery: Encodable {
    
    let oauthToken: String
    
}

struct EmailValidationModel: Codable {
    let message: String
}
// 로그인, 회원가입 모델
struct AuthModel: Codable {
    let user_id: String
    let email: String
    let profileImage: String
    let nick: String
    let accessToken: String
    let refreshToken: String
}
