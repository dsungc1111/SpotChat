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
    let category: String
    let title: String
    let price: Int // 1차적으로 사용 X
    let content: String // 해시태그
    let content1: String // 내용
    let content2: String // 업로드 시간 > 버튼 클릭 시 당시 시각 저장
    let content3: String = "off" // dm 가능여부
    let content4: String = "off"// 인원 모집여부
    let content5: String //
    let files: [String] // 이미지
    let longitude: Double // 게시자 위치
    let latitude: Double // 게시자 위치
}

