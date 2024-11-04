//
//  PostVM.swift
//  SpotChat
//
//  Created by 최대성 on 11/4/24.
//

import Foundation
import Combine

final class PostVM: BaseVMProtocol {
   
    /*
     필요한 게 지금
     - 카테고리
     - 제목
     - content > # 해시태그 용
     - 내용
     - 이미지
     - 업로드 시간
     - DM 가능 여부
     - 게시자 위치
     -
     */
    
    struct PostQuery {
        let category: String
        let title: String
        let price: Int // 1차적으로 사용 X
        let content: String // 해시태그
        let content1: String // 내용
        let content2: String // 업로드 시간 > 버튼 클릭 시 당시 시각 저장
        let content3: String = "off" // dm 가능여부
        let content4: String = "off"// 인원 모집여부
        let content5: String //
        let files: [ String ] // 이미지
        let longitude: Double // 게시자 위치
        let latitude: Double // 게시자 위치
    }
    
    struct Input {
        let postQuery: PostQuery
    }
    
    struct Output {
        
    }
    
    var cancellables = Set<AnyCancellable>()
    
    
    func transform(input: Input) {
        <#code#>
    }
    
    
}
