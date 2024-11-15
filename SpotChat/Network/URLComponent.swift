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
    //MARK: AUTH/User ROUTER
    case emailValidation(query: EmailValidationQuery)
    case signin(query: SigninQuery)
    case appleLogin(query: AppleLgoinQuery)
    case kakaoLogin(query: KakaoLoginQuery)
    case login(query: LoginQuery)
    case myProfile
    case refreshToken
    
    //MARK: POST ROUTER
    case newPost(query: PostQuery)
    case newPostImage(query: PostImageQuery)
    case geolocationBasedSearch(query: GeolocationQuery)
    case findUserPost(String, GetPostQuery?)
}


extension Router: TargetType {
    var baseURL: String {
        return APIKey.baseURL + "v1/"
    }
    
    var method: String {
        switch self {
        case .emailValidation, .signin, .appleLogin, .kakaoLogin, .login, .newPost, .newPostImage:
            return "POST"
        case .refreshToken, .geolocationBasedSearch, .myProfile, .findUserPost:
            return "GET"
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
        case .refreshToken:
            return "auth/refresh"
        case .geolocationBasedSearch:
            return "posts/geolocation"
        case .myProfile:
            return "users/me/profile"
        case .findUserPost(let query, _):
            return "posts/users/\(query)"
        }
    }
    
    var header: [String : String] {
        switch self {
            // 키, 컨텐츠타입 - 제이슨
        case .emailValidation :
            return [
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.developerKey,
                APIKey.HTTPHeaderName.contentType.rawValue : APIKey.HTTPHeaderName.json.rawValue
            ]
            // 키, 컨텐츠타입 - 제이슨, 프로덕트아이디
        case .signin, .appleLogin, .kakaoLogin, .login:
            return [
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.developerKey,
                APIKey.HTTPHeaderName.contentType.rawValue : APIKey.HTTPHeaderName.json.rawValue,
                APIKey.HTTPHeaderName.productID.rawValue : APIKey.HTTPHeaderName.productIDContent.rawValue
            ]
            // 키, 컨텐츠타입 - 제이슨, 프로덕트아이디, 액세[스토큰
        case .newPost:
            return [
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.developerKey,
                APIKey.HTTPHeaderName.contentType.rawValue : APIKey.HTTPHeaderName.json.rawValue,
                APIKey.HTTPHeaderName.productID.rawValue : APIKey.HTTPHeaderName.productIDContent.rawValue,
                APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultsManager.accessToken
                
            ]
            // 키, 컨텐츠타입 - 멀티파트, 프로덕트아이디, 액세스토큰
        case .newPostImage, .myProfile, .findUserPost:
            return [
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.developerKey,
                APIKey.HTTPHeaderName.contentType.rawValue : APIKey.HTTPHeaderName.mutipart.rawValue,
                APIKey.HTTPHeaderName.productID.rawValue : APIKey.HTTPHeaderName.productIDContent.rawValue,
                APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultsManager.accessToken
            ]
            // 키, 컨텐츠타입 - 제이슨, 프로덕트아이디, 토큰 2개
        case .refreshToken:
            return [
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.developerKey,
                APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultsManager.accessToken,
                APIKey.HTTPHeaderName.productID.rawValue : APIKey.HTTPHeaderName.productIDContent.rawValue,
                APIKey.HTTPHeaderName.refresh.rawValue : UserDefaultsManager.refreshToken
            ]
            // 토큰, 키, 프로덕트 아이디
        case .geolocationBasedSearch:
            return [
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.developerKey,
                APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultsManager.accessToken,
                APIKey.HTTPHeaderName.productID.rawValue : APIKey.HTTPHeaderName.productIDContent.rawValue
            ]
        }
    }
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        
        switch self {
            
        case .geolocationBasedSearch(let query):
            
            
            let param = [
                URLQueryItem(name: "longitude", value: query.longitude),
                URLQueryItem(name: "latitude", value: query.latitude),
                URLQueryItem(name: "maxDistance", value: query.maxDistance)
            ]
            
            return param
            
        case .findUserPost(_, let query):
            
            let param = [
                query?.next.map { URLQueryItem(name: "next", value: $0) },
                query?.limit.map { URLQueryItem(name: "limit", value: $0) },
                query?.category.map { URLQueryItem(name: "category", value: $0) }
            ].compactMap { $0 }
            print("===========", param)
            return param.isEmpty ? nil : param
            
        default:
            return nil
        }
    }
    var httpBody: Data? {
        let encoder = JSONEncoder()
        
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
            return encodeMultipartData(postImage)
            
        default:
            return nil
        }
    }
    
    var boundary: String? {
        
        switch self {
        case .newPostImage(let postImage):
            return postImage.boundary
            
        default: return nil
        }
        
    }
    
    func makeRequest() -> URLRequest? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        
        guard let url = components?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = header
        request.httpBody = httpBody
        
        
        if let boundary = boundary {
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
    
    // Multipart Data Encoding
    private func encodeMultipartData(_ postImage: PostImageQuery) -> Data {
        var body = Data()
        
        
        body.append("--\(postImage.boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"files\"; filename=\"image.jpeg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(postImage.imageData ?? body)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(postImage.boundary)--\r\n".data(using: .utf8)!)
        return body
    }
    
}
