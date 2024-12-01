//
//  MapVC.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit
import Combine
//import CoreLocation
import MapKit


final class MapVC: BaseVC {
    
    private let mapView = MapView()
    private let mapVM = MapVM()
    private var currentPopupView: PopupView?
    
    private var cancellables = Set<AnyCancellable>()
    private let temp = CLLocationCoordinate2D(latitude: 37.79181196691732, longitude: 128.9071798324585)
    
    // 여기에 반경에 따른 서치결과 다 담고
    private var sampleGeoResult: [PostModel] = []
    
    // 반경을 바꿨을 때의 List
    private var specifiedPostList: [PostModel] = [] {
        didSet {
            mapView.detailCollectionView.reloadData()
        }
    }
    
    private var userFollower: [Follow] = [] {
        didSet {
            mapView.storyCollectionView.reloadData()
        }
    }
    
    var maxDistance = "5000"
    
    var currentIndex: CGFloat = 0
    
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapView()
        mapView.map.delegate = self
        addTemporaryUserLocation()
        setupCollectionView()
    }
    
    override func bind() {
        
        mapView.myPinBtn.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                let region = MKCoordinateRegion(center: temp, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.map.setRegion(region, animated: true)
            }
            .store(in: &cancellables)
        
        mapView.radiusSetBtn.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                showDistanceSelection()
            }
            .store(in: &cancellables)
        
        mapView.searchBar.textDidChangePublisher
            .subscribe(mapVM.input.searchText)
            .store(in: &cancellables)
        
        mapView.searchBar.searchButtonClickedPublisher
            .subscribe(mapVM.input.searchBtnClicked)
            .store(in: &cancellables)
        
        
        let input = mapVM.input
        let output = mapVM.transform(input: input)
        input.trigger.send(maxDistance)
        
        
        output.geoResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] postModel in
                guard let self else { return }
                guard let maxDistance = Double(maxDistance) else { return }
                
                
                let region = MKCoordinateRegion(center: temp, latitudinalMeters: maxDistance  , longitudinalMeters: maxDistance )
                mapView.map.setRegion(region, animated: true)
                
                
                for post in postModel {
                    let annotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: post.geolocation.latitude, longitude: post.geolocation.longitude))
                    annotation.title = "게시물"
                    annotation.subtitle = "확인"
                    
                    mapView.map.addAnnotation(annotation)
                }
                specifiedPostList = postModel
            }
            .store(in: &cancellables)
        
        
        output.userFollower
            .receive(on: DispatchQueue.main)
            .sink { [weak self] following in
                guard let self else { return }
                print("🐷🐷🐷🐷🐷🐷🐷", following)
                userFollower = following
            }
            .store(in: &cancellables)
        
        
        output.searchList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                print(result)
                guard let self else { return }
                let vc = SearchVC()
                vc.resultList = result
                present(vc, animated: true)
            }
            .store(in: &cancellables)
        
    }
    
    private func setupCollectionView() {
        mapView.storyCollectionView.dataSource = self
        mapView.storyCollectionView.delegate = self
        mapView.detailCollectionView.dataSource = self
        mapView.detailCollectionView.delegate = self
    }
    
    func setMapView() {
        // 지도의 중심 좌표와 줌 레벨 설정
        let center = CLLocationCoordinate2D(latitude: 37.7950773, longitude: 128.8966344)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.map.setRegion(region, animated: true)
    }
    
    
    func addTemporaryUserLocation() {
        let tempAnnotation = MKPointAnnotation()
        tempAnnotation.coordinate = temp
        tempAnnotation.title = "내 위치"
        mapView.map.addAnnotation(tempAnnotation)
    }
}

// MARK: - 반경 변경 기능
extension MapVC {
    private func showDistanceSelection() {
        
        let alert = UIAlertController(title: "거리 선택", message: "검색할 거리를 선택하세요.", preferredStyle: .actionSheet)
        
        // 거리 옵션 배열
        let distances = [500, 1000, 2000, 3000]
        
        
        distances.forEach { distance in
            alert.addAction(UIAlertAction(title: "\(distance)m", style: .default, handler: { [weak self] _ in
                guard let self else { return }
                // 선택한 거리를 ViewModel의 trigger로 전송
                mapVM.input.trigger.send("\(distance)")
                maxDistance = "\(distance)"
            }))
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = mapView.radiusSetBtn
            popoverController.sourceRect = mapView.radiusSetBtn.bounds
        }
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - 어노테이션
extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomAnnotation else { return nil }
        
        let identifier = "CustomAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.subtitleVisibility = .adaptive
        } else {
            annotationView?.annotation = customAnnotation
        }
        
        annotationView?.markerTintColor = AppColorSet.keyColor
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        guard let customAnnotation = annotation as? CustomAnnotation else { return }
        
        specifiedPostList = []
        
        let latitude = annotation.coordinate.latitude
        let longitude = annotation.coordinate.longitude
        let geolocationQuery = GeolocationQuery(longitude: "\(longitude)", latitude: "\(latitude)", maxDistance: "0")
        
        Task {
            do {
                let result = try await NetworkManager2.shared.performRequest(router: .geolocationBasedSearch(query: geolocationQuery), responseType: PostDataModel.self)
                
                specifiedPostList = result.data
                customAnnotation.title = "\(result.data.count)개의 게시물"
                mapView.addAnnotation(customAnnotation)
                
            } catch {
                print("Error fetching posts: \(error)")
            }
        }
        
        let filteredPosts = sampleGeoResult.filter { $0.content1 == customAnnotation.subtitle }
        
        if let matchedPost = filteredPosts.first {
            specifiedPostList = [matchedPost]
        }
    }
    
}

// MARK: - 컬렉션뷰
extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == mapView.storyCollectionView {
            return userFollower.count
        } else {
            return specifiedPostList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == mapView.storyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier, for: indexPath) as! StoryCollectionViewCell
            
            cell.configureCell(following: userFollower[indexPath.item])
            
            
            return cell
            
        } else if collectionView == mapView.detailCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as! DetailCollectionViewCell
            
            cell.configureCell(geoModel: specifiedPostList[indexPath.item])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if let userID = userFollower[indexPath.row].userID { showUserProfile(userID: userID) }
    }
    
    func showUserProfile(userID: String) {
        if let popupView = currentPopupView {
            // 이미 팝업 뷰가 있으면 내용만 업데이트
            Task {
                do {
                    let profile = try await fetchUserProfile(userID: userID)
                    popupView.configure(profile: profile)
                } catch {
                    print("에러 발생:", error)
                }
            }
        } else {
            // 팝업 뷰가 없으면 새로 생성
            let popupView = PopupView()
            popupView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(popupView)
            
            popupView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.8)
                make.height.equalTo(200)
            }
            
            // 팝업 애니메이션
            popupView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                popupView.alpha = 1
            }
            
            // 데이터 요청 및 설정
            Task {
                do {
                    let profile = try await fetchUserProfile(userID: userID)
                    popupView.configure(profile: profile)
                } catch {
                    print("에러 발생:", error)
                }
            }
            
            popupView.DMBtn.tapPublisher
                .sink { [weak self] _ in
                    guard let self else { return }
                    
                    let vc = ChatRoomVC()
                    
                    Task {
                        
                        do {
                            let chatQuery = ChatQuery(opponent_id: popupView.DMBtn.associatedValue ?? "")
                            
                            let result = try await NetworkManager2.shared.performRequest(router: .openChattingRoom(query: chatQuery), responseType: OpenChatModel.self)
                            print(result)
                        } catch let error {
                            print("에잉", error)
                        }
                        
                    }
//                    
//                    
//                    
////                    vc.list = [currenChatList[indexPath.row]]
//                    vc.modalPresentationStyle = .fullScreen
//                    vc.modalTransitionStyle = .crossDissolve
//                    present(vc, animated: true)
                    
                    
                }
                .store(in: &cancellables)
            
            // 제스처 추가
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            popupView.addGestureRecognizer(panGesture)
            
            currentPopupView = popupView // 팝업 뷰 추적
        }
    }
    
    private func fetchUserProfile(userID: String) async throws -> ProfileModel {
        do {
            return try await NetworkManager2.shared.performRequest(
                router: .getUserInfo(query: userID),
                responseType: ProfileModel.self
            )
        } catch {
            throw error
        }
    }
    
}



extension MapVC {
    
    @objc private func handleSwipe(_ gesture: UIPanGestureRecognizer) {
        guard let popupView = gesture.view else { return }
        
        let translation = gesture.translation(in: popupView)
        
        switch gesture.state {
        case .changed:
            // 스와이프한 만큼 팝업을 이동
            popupView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            
        case .ended:
            if translation.y > 80 {
                // 스와이프 거리가 80 초과 시, 팝업 제거
                UIView.animate(withDuration: 0.3, animations: {
                    popupView.transform = CGAffineTransform(translationX: 0, y: popupView.frame.height)
                    popupView.alpha = 0
                }) { _ in
                    popupView.removeFromSuperview()
                    self.currentPopupView = nil
                }
            } else {
                // 스와이프 거리가 충분하지 않으면 원래 위치로 복귀
                UIView.animate(withDuration: 0.3) {
                    popupView.transform = .identity
                }
            }
            
        default:
            break
        }
    }
}
