//
//  ResponseModel.swift
//  SpotChat
//
//  Created by 최대성 on 10/28/24.
//

import Foundation

// 포스트할 이미지 쿼리
struct PostImageQuery: Encodable {
    let boundary = UUID().uuidString
    let imageData: Data?
}

// 포스트할 내용
struct PostQuery: Encodable {
    var category: String
    var title: String
    var price: Int // 1차적으로 사용 X
    var content: String // 해시태그
    var content1: String // 내용
    var content2: String // 업로드 시간 > 버튼 클릭 시 당시 시각 저장
    var content3: String = "off" // dm 가능여부
    var content4: String = "off"// 인원 모집여부
    var content5: String = ""
    var files: [String] // 이미지
    var longitude: Double // 게시자 위치
    var latitude: Double // 게시자 위치
}

// 위치기반 포스트 get 쿼리
struct GeolocationQuery: Encodable {
    let longitude: String
    let latitude: String
    let maxDistance: String
//    let order_by: String
//    let sort_by: String
}
