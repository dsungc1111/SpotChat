//
//  TargetType.swift
//  SpotChat
//
//  Created by 최대성 on 10/28/24.
//

import Foundation

// URLCompnent 구성을 위한 프로토콜

protocol TargetType { 
    
    
    var baseURL: String { get }
    var method: String { get }
    var path: String { get }
    var header: [String : String] { get}
    var parameters: String? { get }
    var queryItems: [URLQueryItem]? { get }
    
    var httpBody: Data? { get }
    var boundary: String? { get }
    
}
