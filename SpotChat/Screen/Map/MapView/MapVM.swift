//
//  File.swift
//  SpotChat
//
//  Created by 최대성 on 11/24/24.
//

import Foundation
import Combine


final class MapVM: BaseVMProtocol {
    
    
    
    var cancellables = Set<AnyCancellable>()
    
    struct Input {
        let trigger = PassthroughSubject<String,Never>()
        let searchText = CurrentValueSubject<String, Never>("")
        let searchBtnClicked = PassthroughSubject<Void,Never>()
    }
    struct Output {
        let geoResult: PassthroughSubject<[PostModel], Never>
        let userFollower: PassthroughSubject<[Follow], Never>
        let searchList: PassthroughSubject<[Follow], Never>
    }
    
    @Published
    var input = Input()
    
    // 위치 기반 게시물 담는
    var geoResult: [PostModel] = []
    // 유져가 팔로잉한 사람들
    var userFollower: [Follow] = []
}


extension MapVM {
    
    func transform(input: Input) -> Output {
        
        
        let geoResult = PassthroughSubject<[PostModel], Never>()
        let followingResult = PassthroughSubject<[Follow], Never>()
        let searchList = PassthroughSubject<[Follow], Never>()
        
        input.trigger
            .sink { [weak self] distance in
                guard let self else { return }
                Task {
                    let (posts, following) = await self.fetchGeolocationData(maxDistance: distance)
                    geoResult.send(posts)
                    
                    followingResult.send(following)
                    
                }
            }
            .store(in: &cancellables)
        
        input.searchText
            .sink { value in
                print(value)
            }
            .store(in: &cancellables)
        
        
        input.searchBtnClicked
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    let result = await self.fetchSearchResult(text: self.input.searchText.value)
                    searchList.send(result)
                }
            }
            .store(in: &cancellables)
        
        return Output(geoResult: geoResult, 
                      userFollower: followingResult,
                      searchList: searchList)
    }
    
}


// 검색
extension MapVM {
    
    private func fetchSearchResult(text: String) async -> [Follow] {
        do {
            let searchList = try await NetworkManager2.shared.performRequest(router: .searchUser(query: text), responseType: UserSearchResult.self)
            
            return searchList.data
        } catch {
            print("유저 검색 실패")
            return []
        }
    }
    
}



// 컬렉션뷰
extension MapVM {
    
    private func fetchGeolocationData(maxDistance: String) async -> ([PostModel], [Follow]) {
        var geoResult: [PostModel] = []
        var userFollower: [Follow] = []

        guard let maxDistance = Double(maxDistance) else {
            print("🥶 형식 전환 실패")
            return ([], [])
        }

        // 위치 기반 데이터 가져오기
        let geolocationQuery = GeolocationQuery(longitude: "128.90782356262207", latitude: "37.805477856609954", maxDistance: "\(maxDistance)")

        do {
            let result = try await NetworkManager2.shared.performRequest(router: .geolocationBasedSearch(query: geolocationQuery), responseType: PostDataModel.self)
            geoResult = result.data
        } catch {
            print("Error fetching geolocation data: \(error)")
        }

        // 유저 정보 가져오기
        do {
            let followList = try await NetworkManager2.shared.performRequest(router: .myProfile, responseType: ProfileModel.self).following
            
            userFollower = followList
        } catch {
            print("유저 에러")
        }

        return (geoResult, userFollower)
    }
}
