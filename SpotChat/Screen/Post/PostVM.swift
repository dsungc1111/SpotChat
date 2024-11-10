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
        let category: String > 위치 기반으로 저장
        let title: String > 제목 구현 0
        let price: Int // 1차적으로 사용 X
        let content: String // 해시태그, 구현 0
        let content1: String // 내용 구현 0
        let content2: String // 업로드 시간 > 버튼 클릭 시 당시 시각 저장 || 버튼 클릭하면 구현 0
        let content3: String = "off" // dm 가능여부 ||구현0
        let content4: String = "off"// 인원 모집여부 || 구현 0
        let content5: String // 게시자 상세위치
        let files: [String] // 이미지 -- 뷰모델에서 바로 전달
        let longitude: Double // 게시자 위치 -- 자동
        let latitude: Double // 게시자 위치 -- 자동
    }
    */
    struct Input {
//        let postImageQuery: PostImageQuery
        let categoryText = CurrentValueSubject<String, Never>("")
        let titleText = CurrentValueSubject<String, Never>("")
        let hashTagText = CurrentValueSubject<String, Never>("")
        let contentText = CurrentValueSubject<String, Never>("")
        let messagePossible = CurrentValueSubject<String, Never>("")
        let meetingPossible = CurrentValueSubject<String, Never>("")
        let postBtnTap = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        
    }
    
    @Published
    var input = Input()
    
    var cancellables = Set<AnyCancellable>()
    
    
    func transform(input: Input) -> Output {

        var postQuery = PostQuery(category: "", title: "", price: 1000, content: "", content1: "", content2: "", files: [], longitude: 128.8966344, latitude: 37.7950773)
        
        input.titleText
            .sink { title in
                print("타이틀 =", title)
                postQuery.title = title
            }
            .store(in: &cancellables)
        
        input.messagePossible
            .sink { dmOn in
                print("디엠 가능? =", dmOn)
                postQuery.content3 = dmOn
            }
            .store(in: &cancellables)
        
        input.meetingPossible
            .sink { meeting in
                print("동행 가능? =", meeting)
                postQuery.content4 = meeting
            }
            .store(in: &cancellables)
        
        input.contentText
            .sink { content in
                postQuery.content1 = content
            }
            .store(in: &cancellables)
        
        input.hashTagText
            .sink { hashTag in
                postQuery.content = hashTag
            }
            .store(in: &cancellables)
        
        input.postBtnTap
            .flatMap { [postQuery] _ in
                Future<PostModel, Error> { promise in
                    Task {
                        do {
                            let result = try await NetworkManager2.shared.performRequest(router: .newPost(query: postQuery), responseType: PostModel.self, retrying: false)
                            promise(.success(result))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                },
                receiveValue: { result in
                    // 성공 시 결과 처리
                    print("Received post: \(result)")
                }
            )
            .store(in: &cancellables)
        
        return Output()
    }
    
}
