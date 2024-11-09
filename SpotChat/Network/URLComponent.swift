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
    case appleLogin(query: AppleLgoinQuery)
    case kakaoLogin(query: KakaoLoginQuery)
    case login(query: LoginQuery)
    case newPost(query: PostQuery)
    case newPostImage(qeury: PostImageQuery)
    
}


extension Router: TargetType {
    var baseURL: String {
        return APIKey.baseURL + "v1/"
    }
    
    var method: String {
        switch self {
        case .emailValidation, .signin, .appleLogin, .kakaoLogin, .login, .newPost, .newPostImage:
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
        case .kakaoLogin:
            return "users/login/kakao"
        case .login:
            return "users/login"
        case .newPost:
            return "posts"
        case .newPostImage:
            return "posts/files"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .emailValidation :
            return [
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.developerKey,
                APIKey.HTTPHeaderName.contentType.rawValue : APIKey.HTTPHeaderName.json.rawValue
            ]
        case .signin, .appleLogin, .kakaoLogin, .login:
            return [
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.developerKey,
                APIKey.HTTPHeaderName.contentType.rawValue : APIKey.HTTPHeaderName.json.rawValue,
                APIKey.HTTPHeaderName.productID.rawValue : APIKey.HTTPHeaderName.productIDContent.rawValue
            ]
            
        case .newPost, .newPostImage:
            return [
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.developerKey,
                APIKey.HTTPHeaderName.contentType.rawValue : APIKey.HTTPHeaderName.json.rawValue,
                APIKey.HTTPHeaderName.productID.rawValue : APIKey.HTTPHeaderName.productIDContent.rawValue,
                APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultManager.accessToken
            
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
        case .signin(let query):
            return try? encoder.encode(query)
        case .appleLogin(let query):
            return try? encoder.encode(query)
        case .kakaoLogin(let query):
            return try? encoder.encode(query)
        case .login(let query):
            return try? encoder.encode(query)
        case .newPost(query: let query):
            return try? encoder.encode(query)
        case .newPostImage(let postImage):
            
            var body = Data()
            // 첫번째 경계
            body.append("--\(postImage.boundary)\r\n".data(using: .utf8)!)
            // 파일 메타 정보 추가, name과 filename속성 지정
            body.append("Content-Disposition: form-data; name=\"files\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            // MIME 타입 지정
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            // 이미지 데이터 추가
            body.append(postImage.imageData ?? Data())
            // 데이터 파트 종료 식별
            body.append("\r\n".data(using: .utf8)!)
            // multipart 형식의 종료 명시
            body.append("--\(postImage.boundary)--\r\n".data(using: .utf8)!)
            
            return body
        }
    }
    
    var boundary: String? {
        
        switch self {
        case .newPostImage(let postImage):
            return postImage.boundary
            
        default:
            return nil
        }
        
    }
    func makeRequest() -> URLRequest? {
        guard let url = URL(string: baseURL + path) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = header
        request.httpBody = httpBody
        return request
        
        
//        guard let url = URL(string: baseURL + path) else { return nil }
//          var request = URLRequest(url: url)
//          request.httpMethod = method
//          var headers = header
//          if case .newPostImage(let postImage) = self {
//              headers[APIKey.HTTPHeaderName.contentType.rawValue] = "multipart/form-data; boundary=\(postImage.boundary)"
//          }
//        
//          request.allHTTPHeaderFields = headers
//          request.httpBody = httpBody
//          return request
    }
    
}
