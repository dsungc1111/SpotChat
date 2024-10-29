//
//  URLComponent.swift
//  SpotChat
//
//  Created by 최대성 on 10/28/24.
//

import Foundation

/*
 모든 요청: 헤더에 Key값 넣어야함
 회원인증 요청을 제외한 모든 요청 헤더에 authorization - accesstoken
 
 */

enum Router {
    case emailValidation(query: EmailValidationQuery)
    case signin(query: SigninQuery)
    case appleLogin
}


extension Router: TargetType {
    var baseURL: String {
        return APIKey.baseURL + "v1/"
    }
    
    var method: String {
        switch self {
        case .emailValidation, .signin, .appleLogin:
            return "POST"
        }
    }
    
    var path: String {
        switch self {
        case .emailValidation:
            return "users/validation/email"
        case .signin:
            return "users/join"
        case .appleLogin:
            return "users/login/apple"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .emailValidation :
            return [
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.developerKey,
                APIKey.HTTPHeaderName.contentType.rawValue : APIKey.HTTPHeaderName.json.rawValue
            ]
        case .signin, .appleLogin:
            return [
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.developerKey,
                APIKey.HTTPHeaderName.contentType.rawValue : APIKey.HTTPHeaderName.json.rawValue,
                APIKey.HTTPHeaderName.productID.rawValue : APIKey.HTTPHeaderName.productIDContent.rawValue
            ]
        }
    }
    
    var parameters: [URLQueryItem]? {
        return nil
    }
    
    var httpBody: Data? {
        let encoder = JSONEncoder()
        print("~~~~~인코딩~~~~~~")
        switch self {
        case .emailValidation(let query):
            return try? encoder.encode(query)
        case .signin(query: let query):
            return try? encoder.encode(query)
        case .appleLogin:
            return nil
        }
    }
    
    var boundary: String? {
        return nil
    }
    func makeRequest() -> URLRequest? {
        guard let url = URL(string: baseURL + path) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = header
        request.httpBody = httpBody
        return request
    }
    
}
