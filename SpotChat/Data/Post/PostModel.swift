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
    let distance: Double?

    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case category, title, price, content, content1, content2, content3, content4, content5, createdAt, creator, files, likes, likes2, buyers, hashTags, comments, geolocation, distance
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


struct GeolocationBasedDataModel: Codable {
    let data: [PostModel]
}
//
//struct GeolocationModel: Codable {
//    let longitude: String
//    let latitude: String
//}


/*
 {
   "data": [
     {
       "post_id": "670bcd66539a670e42b2a3d8",
       "category": "study",
       "title": "스터디원 모집합니다",
       "price": 100,
       "content": "오늘 밥 뭐 먹지 🤤 #영등포 #청취사 #새싹",
       "content1": "8000원",
       "content2": "영등포캠퍼스",
       "content3": "저녁에 스터디 하실분",
       "content4": "붕어빵 드실분",
       "content5": "slp 같이 하실 분",
       "createdAt": "2024-10-19T03:05:03.422Z",
       "creator": {
         "user_id": "65c9aa6932b0964405117d97",
         "nick": "jack",
         "profileImage": "uploads/profiles/1707716853682.png"
       },
       "files": [
         "uploads/posts/스크린샷 2024-03-08 오후 11.11.05_1712739634962.png"
       ],
       "likes": [
         "65c9aa6932b0964405117d97"
       ],
       "likes2": [
         "670bcd66539a670e42b2a3d8"
       ],
       "buyers": [
         "65c9aa6932b0964405117d08"
       ],
       "hashTags": [
         "영등포"
       ],
       "comments": [
         {
           "comment_id": "65c9bc50a76c82debcf0e3e3",
           "content": "할수있다 !! 포트폴리오 가즈아 ! 🔥",
           "createdAt": "2024-02-12T06:36:00.073Z",
           "creator": {
             "user_id": "65c9aa6932b0964405117d97",
             "nick": "jack",
             "profileImage": "uploads/profiles/1707716853682.png"
           }
         }
       ],
       "geolocation": {
         "longitude": 126.886557,
         "latitude": 37.51775
       },
       "distance": 75.42775857964551
     }
   ]
 }
 */
