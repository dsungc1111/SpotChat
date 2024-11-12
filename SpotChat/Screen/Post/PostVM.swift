//
//  PostVM.swift
//  SpotChat
//
//  Created by 최대성 on 11/4/24.
//

import Foundation
import Combine

final class PostVM: BaseVMProtocol {
    
  
    struct Input {
        let postImageQuery = CurrentValueSubject<PostImageQuery, Never>(PostImageQuery(imageData: Data()))
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
    
    private var postQuery = PostQuery(category: "", title: "", price: 1000, content: "", content1: "", content2: "", files: [], longitude: 128.8966344, latitude: 37.7950773)
    
    @Published
    var input = Input()
    
    var cancellables = Set<AnyCancellable>()
    
    
    func transform(input: Input) -> Output {
        
   
        
        input.titleText
            .sink { [weak self] title in
                guard let self else { return }
                postQuery.title = title
            }
            .store(in: &cancellables)
        
        input.messagePossible
            .sink { [weak self] dmOn in
                guard let self else { return }
                postQuery.content3 = dmOn
            }
            .store(in: &cancellables)
        
        input.meetingPossible
            .sink { [weak self] meeting in
                guard let self else { return }
                postQuery.content4 = meeting
            }
            .store(in: &cancellables)
        
        input.contentText
            .sink { [weak self] content in
                guard let self else { return }
                postQuery.content1 = content
            }
            .store(in: &cancellables)
        
        input.hashTagText
            .sink { [weak self] hashTag in
                guard let self else { return }
                postQuery.content = hashTag
            }
            .store(in: &cancellables)
        
        input.postBtnTap
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.performPostSequence(postQuery: self.postQuery)
                }
            }
            .store(in: &cancellables)
        
        return Output()
    }
    
    func performPostSequence(postQuery: PostQuery) async {
        
        var post = postQuery
        do {
            // 첫 번째 요청: 이미지 업로드
            let postImageQuery = PostImageQuery(imageData: input.postImageQuery.value.imageData)
            let imageResult = try await NetworkManager2.shared.performRequest(
                router: .newPostImage(query: postImageQuery),
                responseType: PostImageModel.self,
                retrying: false
            )

            // 두 번째 요청을 위해 postQuery에 파일 정보 추가
            post.files = imageResult.files

            // 두 번째 요청: 게시물 생성
            let postResult = try await NetworkManager2.shared.performRequest(
                router: .newPost(query: post),
                responseType: PostModel.self,
                retrying: false
            )

            // 성공적으로 결과를 얻었을 때의 처리
            print("⭐️ Received post: \(postResult) ⭐️")

        } catch {
            // 에러 발생 시 처리
            print("Error: \(error)")
        }
    }
}
