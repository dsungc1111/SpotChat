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

class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}


final class MapVC: BaseVC {
    
    private let mapView = MapView()
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
    
    // 초기세팅 - 5000m 범위
    func setAnnotation() { fetchGeolocationData(maxDistance: "5000") }
    
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
        
        userFollower = []
        
        Task {
            
            guard let maxDistance = Double(maxDistance) else { return }
            
            let region = MKCoordinateRegion(center: temp, latitudinalMeters: maxDistance / 2 , longitudinalMeters: maxDistance / 2)
            mapView.map.setRegion(region, animated: true)
            
            let geolocationQuery = GeolocationQuery(longitude: "128.90782356262207", latitude: "37.805477856609954", maxDistance: "\(maxDistance)")
            
            do {
                let result = try await NetworkManager2.shared.performRequest(router: .geolocationBasedSearch(query: geolocationQuery), responseType: PostDataModel.self)
                
                
                
                for post in result.data {
                    let annotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: post.geolocation.latitude, longitude: post.geolocation.longitude))
                    
                    sampleGeoResult.append(post)
                    mapView.map.addAnnotation(annotation)
                }
                
            } catch {
                print("Error fetching geolocation data: \(error)")
            }
            
            
            do {
                let userInfo = try await NetworkManager2.shared.performRequest(router: .myProfile, responseType: ProfileModel.self)
                
                
                let followingSet = Set(userInfo.following.map { $0.userID })
                var addedUserIDs = Set(userFollower.map { $0.userID })
                
                for geo in sampleGeoResult {
                    let creatorID = geo.creator.userID
                    
                    if followingSet.contains(creatorID) && !addedUserIDs.contains(creatorID) {
                        if let matchingUser = userInfo.following.first(where: { $0.userID == creatorID }) {
                            
                            userFollower.append(matchingUser)
                            addedUserIDs.insert(creatorID)
                            
                        }
                    }
                }
            } catch {
                print("유저 에러")
            }
        }
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
                customAnnotation.subtitle = "\(result.data.count)개의 게시물"
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
        print(indexPath.item, "번 선택!!!!!!!!!")
    }
    
}

