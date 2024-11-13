//
//  NetworkManager.swift
//  SpotChat
//
//  Created by 최대성 on 10/28/24.
//

import Foundation
import Combine

// 👉👉👉👉👉👉👉 클로저 형태 - URLSession
final class NetworkManager {
    
    static let shared = NetworkManager()
    
    func performRequest<T: Codable>(router: Router, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        print("네트워크 메서드 실행")
        guard let request = router.makeRequest() else {
            print("url 에러임")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data,
               let httpResponse = response as? HTTPURLResponse {
                
                if 200..<300 ~= httpResponse.statusCode {
                    
                    do {
                        print("👍응답성공")
                        let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                        completion(.success(decodedResponse))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    print("data 없음, status code: \(httpResponse.statusCode)")
                }
            } else {
                print("data 또는 response 변환 실패")
            }
            
            
        }
        task.resume()
    }
}

// 👉👉👉👉👉👉👉 Combine활용 - URLSession
//final class NetworkManager {
//
//    static let shared = NetworkManager()
//
//    private init() {}
//
//
//    func performRequest<T: Decodable>(router: Router, responseType: T.Type) -> AnyPublisher<T, Error> {
//
//        guard let request = router.makeRequest() else {
//            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
//        }
//
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { data, response in
//                guard let httpResponse = response as? HTTPURLResponse,
//                        200..<300 ~= httpResponse.statusCode else {
//                    throw URLError(.badServerResponse)
//                }
//
//                print("응답성공")
//                return data
//            }
//            .decode(type: responseType, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
//
//}

// 👉👉👉👉👉👉👉 swift concurrency
final class NetworkManager2 {
    
    static let shared = NetworkManager2()
    
    private init() {}
    
    func performRequest<T: Decodable>(router: Router, responseType: T.Type, retrying: Bool = false) async throws -> T {
        
        guard let request = router.makeRequest() else {
            throw URLError(.badURL)
        }
        
        print("요청 라우터: \(request)")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("🔫🔫🔫🔫🔫응답 상태 코드: \(httpResponse.statusCode)🔫🔫🔫🔫🔫")
        
        switch httpResponse.statusCode {
        case 200..<300:
            print("성공인데유")
            print("🍿🍿🍿🍿🍿액세스 토큰", UserDefaultManager.accessToken)
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                return decodedResponse
            } catch {
                throw error
            }
        
        case 401, 403, 418:
            print("로그인 화면으로 이동 (401 or 403 or 418 상태)")
            NotificationCenter.default.post(
                name: NSNotification.Name("ExpiredRefreshToken"),
                object: nil
            )
            throw URLError(.userAuthenticationRequired)
            
        case 419:
            
            guard !retrying else {
                throw URLError(.userAuthenticationRequired)
            }
            
            do {
                // 리프레시 토큰으로 새로운 액세스 토큰 요청
                let refreshedToken = try await refreshAccessToken()
                
                // 갱신된 토큰으로 UserDefaultManager 업데이트
                UserDefaultManager.accessToken = refreshedToken.accessToken
                UserDefaultManager.refreshToken = refreshedToken.refreshToken
                
                print("🥶🥶🥶🥶🥶🥶토큰 갱신 후 액세스 토큰:", UserDefaultManager.accessToken)
                print("🥶🥶🥶🥶🥶🥶토큰 갱신 후 리프레시 토큰:", UserDefaultManager.refreshToken)
                
                // 갱신된 토큰으로 원래 요청을 재시도
                return try await self.performRequest(router: router, responseType: responseType, retrying: true)
                
            } catch {
                print("토큰 갱신 실패: \(error)")
                throw URLError(.userAuthenticationRequired)
            }
            
        default:
            print("예외 응답 코드:", httpResponse.statusCode)
            throw URLError(.badServerResponse)
        }
    }
    
    private func refreshAccessToken() async throws -> TokenModel {
        // 리프레시 토큰으로 새로운 액세스 토큰 요청
        return try await performRequest(router: .refreshToken, responseType: TokenModel.self, retrying: false)
    }
}
