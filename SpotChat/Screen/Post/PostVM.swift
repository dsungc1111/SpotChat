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
        let files: [String] // 이미지 -- 뷰모델에서 바로 전달
        let longitude: Double // 게시자 위치 -- 자동
        let latitude: Double // 게시자 위치 -- 자동
    }
    */
    struct Input {
//        let postImageQuery: PostImageQuery
        let categoryText: PassthroughSubject<String, Never>
        let titleText: PassthroughSubject<String, Never>
        let hashTagText: PassthroughSubject<String, Never>
        let contentText: PassthroughSubject<String, Never>
        let messagePossible: PassthroughSubject<String, Never>
        let meetingPossible: PassthroughSubject<String, Never>
        let postBtnTap: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        
    }
    
    var cancellables = Set<AnyCancellable>()
    

    
    func transform(input: Input) -> Output {

        
        input.postBtnTap
            .sink { _ in
                print("탭탭")
            }
            .store(in: &cancellables)
        
        return Output()
    }
    
}
