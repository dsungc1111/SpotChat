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


struct ImageItem: Hashable {
    let id = UUID()
    let image: UIImage
}

final class MapVC: BaseVC {
    
    private let mapView = MapView()
    private var cancellables = Set<AnyCancellable>()
    private let temp = CLLocationCoordinate2D(latitude: 37.79181196691732, longitude: 128.9071798324585)
    var geoResult: [PostModel] = []
    
    var userFollower: [Follow] = [] {
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
    
    func setAnnotation() {
        
        Task {
            let geolocationQuery = GeolocationQuery(longitude: "128.90782356262207", latitude: "37.805477856609954", maxDistance: "2000")
            
            do {
                let result = try await NetworkManager2.shared.performRequest(router: .geolocationBasedSearch(query: geolocationQuery), responseType: PostDataModel.self)
                geoResult = result.data
                
                
                for i in 0..<result.data.count {  // `locations`는 GeolocationBasedDataModel 내의 위치 배열이라고 가정합니다.
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: result.data[i].geolocation.latitude, longitude: result.data[i].geolocation.longitude)
                    //                    annotation.title = result.data[i].content.
                    annotation.subtitle = result.data[i].content1  // `description`은 위치에 대한 설명
                    
                    mapView.map.addAnnotation(annotation)
                }
                mapView.detailCollectionView.reloadData()
            } catch {
                print("Error fetching geolocation data: \(error)")
            }
            
            
            do {
                let userInfo = try await NetworkManager2.shared.performRequest(router: .myProfile, responseType: ProfileModel.self)
                
                print("🚧🚧🚧🚧🚧🚧🚧🚧🚧 = ", userInfo.following)
                print("dfsdfdsfdsfdf", geoResult.count)
                for i in 0..<geoResult.count {
                    dump(geoResult[i].creator)
                    for j in 0..<userInfo.following.count {
                        
                        if userInfo.following[j].userID == geoResult[i].creator.userID {
                            
                            userFollower.append(userInfo.following[j])
                        }
                        
                    }
                    
                }
                
                
                print("🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶팔로워 소개 드갑니다이 ~ ", userFollower)
                
            } catch {
                print("유저 에러")
            }
        }
    }
    func addTemporaryUserLocation() {
        let tempAnnotation = MKPointAnnotation()
        tempAnnotation.coordinate = temp
        tempAnnotation.title = "내 위치"
        mapView.map.addAnnotation(tempAnnotation)
    }
}


extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let identifier = "CustomAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor =  AppColorSet.keyColor
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
}


extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("0000000000000", userFollower.count)
        
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
}

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

