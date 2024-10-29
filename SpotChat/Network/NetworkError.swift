//
//  NetworkError.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import Foundation


enum NetworkError: Error {
    case invalidResponse
    case invalidError
    case noData
    case decodingError
    case serverError
    case unkwonedError
}
