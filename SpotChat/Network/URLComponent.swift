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
    case editProfile(query: EditUserQuery)
    case searchUser(query: String)
    case getUserInfo(query: String)
    
    //MARK: POST ROUTER
    case newPost(query: PostQuery)
    case newPostImage(query: PostImageQuery)
    case geolocationBasedSearch(query: GeolocationQuery)
    case findUserPost(String, GetPostQuery?)
    
    //MARK: Chat Router
    case openChattingRoom(query: ChatQuery)
    case getChattingList
    case sendChat(String, SendChatQuery)
    case getChatContent(String, String?)
    case sendFiles(String, PostImageQuery)
}


extension Router: TargetType {
    var baseURL: String {
        return APIKey.baseURL + "v1/"
    }
    
    var method: String {
        switch self {
        case .emailValidation, .signin, .appleLogin, .kakaoLogin, .login, .newPost, .newPostImage, .openChattingRoom, .sendChat, .sendFiles:
            return "POST"
        case .refreshToken, .geolocationBasedSearch, .myProfile, .findUserPost, .searchUser, .getChattingList, .getChatContent, .getUserInfo:
            return "GET"
        case .editProfile:
            return "PUT"
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
        case .editProfile:
            return "users/me/profile"
        case .searchUser:
            return "users/search"
        case .openChattingRoom:
            return "chats"
        case .getChattingList:
            return "chats"
        case .sendChat(let query, _), .getChatContent(let query, _):
            return "chats/\(query)"
        case .sendFiles(let query, _):
            return "chats/\(query)/files"
        case .getUserInfo(let query):
            return "users/\(query)/profile"
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
        case .newPost, .openChattingRoom, .getChattingList, .sendChat, .getChatContent, .getUserInfo:
            return [
                APIKey.HTTPHeaderName.sesacKey.rawValue : APIKey.developerKey,
                APIKey.HTTPHeaderName.contentType.rawValue : APIKey.HTTPHeaderName.json.rawValue,
                APIKey.HTTPHeaderName.productID.rawValue : APIKey.HTTPHeaderName.productIDContent.rawValue,
                APIKey.HTTPHeaderName.authorization.rawValue : UserDefaultsManager.accessToken
                
            ]
            // 키, 컨텐츠타입 - 멀티파트, 프로덕트아이디, 액세스토큰
        case .newPostImage, .myProfile, .findUserPost, .editProfile, .sendFiles:
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
        case .geolocationBasedSearch, .searchUser:
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
            
        case .searchUser(let query):
            
            let param = [
                URLQueryItem(name: "nick", value: query)
            ]
            
            return param
            
        case .sendChat(let query, _):
            
            let param = [
                URLQueryItem(name: "room_id", value: query)
            ]
            
            return param
            
        case .getChatContent(let roodId, let cursor):
            
            let param = [
                URLQueryItem(name: "room_id", value: roodId),
                URLQueryItem(name: "cursor_date", value: cursor)
            ]
            
            return param
            
        case .getUserInfo(let userId):
            
            let param = [
                URLQueryItem(name: "user_id", value: userId)
            ]
            
            return param
            
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
        case .newPostImage(let postImage), .sendFiles(_, let postImage):
            return encodeMultipartData(postImage)
        case .editProfile(let query):
            return editUserProfile(query)
            
        case .openChattingRoom(let query):
            return try? encoder.encode(query)
            
        case .sendChat(_, let sendQeury):
            return try? encoder.encode(sendQeury)
            
        default:
            return nil
        }
    }
    
    var boundary: String? {
        
        switch self {
        case .newPostImage(let postImage):
            return postImage.boundary
        case .editProfile(let editUser):
            return editUser.boundary
        case .sendFiles(_, let postImage):
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
            print("🔫🔫🔫🔫🔫🔫🔫🔫🔫🔫🔫🔫🔫🔫바운더리 있으")
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
    
    private func encodeMultipartData(_ postImage: PostImageQuery) -> Data {
        var body = Data()
        
        for (index, imageData) in postImage.imageData.enumerated() {
            let fileName = "image_\(index).jpeg" // 파일 이름에 인덱스 추가
            
            body.append("--\(postImage.boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(postImage.boundary)--\r\n".data(using: .utf8)!)
        return body
    }
    
    
    
    private func editUserProfile(_ editProfile: EditUserQuery) -> Data {
        var body = Data()
        
        // `nick`
        body.append("--\(editProfile.boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"nick\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(editProfile.nick)\r\n".data(using: .utf8)!)
        
        // `info1` - bio
        body.append("--\(editProfile.boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"info1\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(editProfile.info1)\r\n".data(using: .utf8)!)
        
        // `profile` (이미지)
        if let profileData = editProfile.profile {
            
            body.append("--\(editProfile.boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"profile\"; filename=\"profile.png\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(profileData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // 종료 boundary
        body.append("--\(editProfile.boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
}
