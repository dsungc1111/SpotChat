//
//  MapVC.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit
import Combine
import CoreLocation
import MapKit



final class MapVC: BaseVC {
    
    private let mapView = MapView()
    private var cancellables = Set<AnyCancellable>()
    private let temp = CLLocationCoordinate2D(latitude: 37.79181196691732, longitude: 128.9071798324585)
    
    private var sampleGeoResult: [PostModel] = []
    
    private var geoResult: [PostModel] = [] {
        didSet {
            mapView.detailCollectionView.reloadData()
        }
    }
    
    private var userFollower: [Follow] = [] {
        didSet {
            mapView.storyCollectionView.reloadData()
        }
    }
    
    var currentIndex: CGFloat = 0
    
    
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMapView()
        setAnnotation()
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
    
    // 초기세팅 - 2000m 범위
    func setAnnotation() {
        
        fetchGeolocationData(maxDistance: "1000")
    }
    
    func addTemporaryUserLocation() {
        let tempAnnotation = MKPointAnnotation()
        tempAnnotation.coordinate = temp
        tempAnnotation.title = "내 위치"
        mapView.map.addAnnotation(tempAnnotation)
    }
}

// MARK: - 네트워크
extension MapVC {
    
    private func showDistanceSelection() {
        let alert = UIAlertController(title: "거리 선택", message: "검색할 거리를 선택하세요.", preferredStyle: .actionSheet)
        
        // 거리 옵션 배열
        let distances = [500, 1000, 2000, 3000]
        
        
        distances.forEach { distance in
            alert.addAction(UIAlertAction(title: "\(distance)m", style: .default, handler: { [weak self] _ in
                
                self?.fetchGeolocationData(maxDistance: "\(distance)")
            }))
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = mapView.radiusSetBtn
            popoverController.sourceRect = mapView.radiusSetBtn.bounds
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func fetchGeolocationData(maxDistance: String) {
        
        Task {
            
            guard let maxDistance = Double(maxDistance) else { return }
            
            let region = MKCoordinateRegion(center: temp, latitudinalMeters: maxDistance, longitudinalMeters: maxDistance)
            mapView.map.setRegion(region, animated: true)
            
            let geolocationQuery = GeolocationQuery(longitude: "128.90782356262207", latitude: "37.805477856609954", maxDistance: "\(maxDistance)")
            
            do {
                let result = try await NetworkManager2.shared.performRequest(router: .geolocationBasedSearch(query: geolocationQuery), responseType: PostDataModel.self)
                
                
                
                for i in 0..<result.data.count {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: result.data[i].geolocation.latitude, longitude: result.data[i].geolocation.longitude)
                    
                    annotation.subtitle = result.data[i].content1
                    geoResult.append(result.data[i])
                    sampleGeoResult.append(result.data[i])
                    mapView.map.addAnnotation(annotation)
                }
                
            } catch {
                print("Error fetching geolocation data: \(error)")
            }
            
            
            do {
                let userInfo = try await NetworkManager2.shared.performRequest(router: .myProfile, responseType: ProfileModel.self)
                
                print("🚧🚧🚧🚧🚧🚧🚧🚧🚧 = ", userInfo.following)
                print("dfsdfdsfdsfdf", geoResult.count)
                
                let followingSet = Set(userInfo.following.map { $0.userID })
                var addedUserIDs = Set(userFollower.map { $0.userID })

                for geo in geoResult {
                    let creatorID = geo.creator.userID

                    if followingSet.contains(creatorID) && !addedUserIDs.contains(creatorID) {
                        if let matchingUser = userInfo.following.first(where: { $0.userID == creatorID }) {
                            userFollower.append(matchingUser)
                            addedUserIDs.insert(creatorID)
                        }
                    }
                }
                
                print("🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶팔로워 소개 드갑니다이 ~ ", userFollower)
                
            } catch {
                print("유저 에러")
            }
        }
    }
}

// MARK: - 어노테이션
extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let identifier = "CustomAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.markerTintColor = AppColorSet.keyColor
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        guard let subtitle = annotation.subtitle as? String else { return }
        
        
        
        print("subtitle🔫🔫🔫🔫🔫🔫🔫🔫🔫🔫 = ", subtitle)
        let filteredPosts = sampleGeoResult.filter { $0.content1 == subtitle }
        
        if let matchedPost = filteredPosts.first {
            updateDetailCollectionView(with: matchedPost)
        }
    }
    private func updateDetailCollectionView(with post: PostModel) {
        // 선택된 포스트만 표시
        geoResult = [post]  // `geoResult`를 재정의하여 컬렉션뷰를 업데이트
        
        
//        Task {
//            
//            let geolocationQuery = GeolocationQuery(longitude: "128.90782356262207", latitude: "37.805477856609954", maxDistance: "\(2000)")
//            
//            do {
//                let result = try await NetworkManager2.shared.performRequest(router: .geolocationBasedSearch(query: geolocationQuery), responseType: PostDataModel.self)
//                
//                geoResult = result.data
//                
//            } catch {
//                print("업데이트 후 geomodel 원래로 복귀")
//            }
//        }
        
    }
}

// MARK: - 컬렉션뷰
extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if collectionView == mapView.storyCollectionView {
            return userFollower.count
        } else {
            return geoResult.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == mapView.storyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier, for: indexPath) as! StoryCollectionViewCell
            
            cell.configureCell(following: userFollower[indexPath.item])
            
            
            return cell
            
        } else if collectionView == mapView.detailCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as! DetailCollectionViewCell
            
            cell.configureCell(geoModel: geoResult[indexPath.item])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item, "번 선택!!!!!!!!!")
        
        
        
        
    }
}


// MARK: - 컬렉션뷰 페이징
extension MapVC : UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        guard let collectionView = scrollView as? UICollectionView else { return }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
        // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
        // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        if currentIndex > roundedIndex {
            currentIndex -= 1
            roundedIndex = currentIndex
        } else if currentIndex < roundedIndex {
            currentIndex += 1
            roundedIndex = currentIndex
        }
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

