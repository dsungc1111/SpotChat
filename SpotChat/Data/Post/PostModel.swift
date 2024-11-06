//
//  PostModel.swift
//  SpotChat
//
//  Created by 최대성 on 11/5/24.
//

import Foundation


// 이미지 응답 모델
struct PostImageModel: Codable {
    let files: [String]
}

//  포스트 응답 모델
struct PostModel: Codable {
    let postID, category, title: String
    let price: Int
    let content, content1, content2, content3: String
    let content4, content5, createdAt: String
    let creator: Creator
    let files, likes, likes2, buyers: [String]
    let hashTags: [String]
    let comments: [Comment]
    let geolocation: Geolocation
//    let distance: Double

    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case category, title, price, content, content1, content2, content3, content4, content5, createdAt, creator, files, likes, likes2, buyers, hashTags, comments, geolocation
    }
}

//  댓글
struct Comment: Codable {
    let commentID, content, createdAt: String
    let creator: Creator

    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case content, createdAt, creator
    }
}

//  작성자 정보
struct Creator: Codable {
    let userID, nick, profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick, profileImage
    }
}

//  작성자 위치
struct Geolocation: Codable {
    let longitude, latitude: Double
}

