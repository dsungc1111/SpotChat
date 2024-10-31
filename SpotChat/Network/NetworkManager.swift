//
//  NetworkManager.swift
//  SpotChat
//
//  Created by 최대성 on 10/28/24.
//

import Foundation
import Combine


final class NetworkManager {
    
    static let shared = NetworkManager()
    
    func performRequest<T: Codable>(router: Router, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
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
                    // 성공적인 응답이므로 원하는 동작 수행
                    do {
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
