//
//  SettingVM.swift
//  SpotChat
//
//  Created by 최대성 on 11/14/24.
//

import Foundation
import Combine
final class SettingVM: BaseVMProtocol {
    
    var cancellables: Set<AnyCancellable> = []
    
    struct Input {
        let trigger: PassthroughSubject<String, Never>
    }
    
    struct Output {
        let myInfoList: PassthroughSubject<ProfileModel, Never>
        let myImageList: PassthroughSubject<[String], Never>
    }
    
    func transform(input: Input) -> Output {
        
        let myInfoList = PassthroughSubject<ProfileModel, Never>()
        let myImageList = PassthroughSubject<[String], Never>()
        
        input.trigger
            .sink { userID in
                
                Task {
                    do {
                        // 사용자 프로필 불러오기
                        let profileModel = try await NetworkManager2.shared.performRequest(router: .myProfile, responseType: ProfileModel.self)
                        myInfoList.send(profileModel)
                        
                        // 사용자 게시물 이미지 불러오기
                        let query = GetPostQuery(next: nil, limit: nil, category: nil)
                        let postData = try await NetworkManager2.shared.performRequest(router: .findUserPost(userID, query), responseType: PostDataModel.self)
                        
                        var imageDataList: [String] = []
                        
                        for post in postData.data {
                            for path in post.files {
                                imageDataList.append(path)
                            }
                        }
                        
                        myImageList.send(imageDataList)
                        
                    } catch {
                        print("Error loading data: \(error)")
                    }
                }
            }
            .store(in: &cancellables)
        
        return Output(myInfoList: myInfoList, myImageList: myImageList)
    }
}
