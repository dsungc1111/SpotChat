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
//
//final class MapVC: BaseMapVC, UICollectionViewDelegateFlowLayout {
//
//    private let mapView = MapView()
//
//    private var logtitude = 128.9072
//    private var latitude = 37.7918
//
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func addViews() {
//
//        /*
//         - viewName: 추가할 kakaomap sdk의 name
//         - viewInfoNAme: baseMap의 viewInfo 이름
//         - defaultPosition: 초기위치 > 미지정 시, 서울시청이 기본값
//         - defaultLevel: 초기 레벨값 > 미지정 시, 17 > 각 레벨별로 카메라가 지도를 바라보는 높이값
//         - enabled: 초기 활성화 여부 > 미지정 시, true
//        */
//        let defaultPosition: MapPoint = MapPoint(longitude: logtitude, latitude: latitude)
//        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 6)
//
//        mapController?.addView(mapviewInfo)
//    }
//
//    override func viewInit(viewName: String) {
//        createLodLabelLayer {
//            // 레이어 추가가 성공한 후에만 POI 생성 메서드를 호출
//            self.createLodPois()
//        }
//    }
//
//    func createLodLabelLayer(completion: @escaping () -> Void) {
//        guard let view = mapController?.getView("mapview") as? KakaoMap else {
//            print("🤬 Map view not found in \(#function)")
//            return
//        }
//
//        let manager = view.getLabelManager()
//        let custom = LodLabelLayerOptions(layerID: "PoiLayer", competitionType: .sameLower, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 5000, radius: _radius)
//
//        if let addedLayer = manager.addLodLabelLayer(option: custom) {
//            print("Layer 'PoiLayer' successfully added: \(addedLayer)")
//            completion() // 레이어 추가 후 콜백 호출
//        } else {
//            print("Failed to add layer 'PoiLayer'")
//        }
//    }
//
//
//
//
//    func createLodPois() {
//        print("😣😣😣😣😣😣😣😣😣😣😣😣😣😣😣😣😣😣😣😣😣여기는?????😣😣😣😣😣😣😣😣😣😣😣😣😣")
//        Task {
//            do {
//                let geolocationQuery = GeolocationQuery(longitude: "\(128.90782356262207)", latitude: "\(37.805477856609954)", maxDistance: "\(2000)")
//                let result = try await NetworkManager2.shared.performRequest(router: .geolocationBasedSearch(query: geolocationQuery), responseType: GeolocationBasedDataModel.self)
//                // 받아온 POIs 데이터를 기반으로 지도에 POI를 표시
//                createLodPois(with: result)
//            } catch {
//                print("POIs 로딩 중 오류 발생: \(error)")
//            }
//        }
//
//    }
//    func createLodPois(with pois: GeolocationBasedDataModel) {
//        guard let view = mapController?.getView("mapview") as? KakaoMap else {
//            print("🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬🤬\(#function)")
//            return
//        }
//        let manager = view.getLabelManager()
//
//
//
//        // "PoiLayer"가 존재하는지 확인하고 가져옴
//        guard let layer = manager.getLabelLayer(layerID: "PoiLayer") else {
//            print("Layer with ID 'PoiLayer' does not exist.")
//            return
//        }
//
//        let poiOption = PoiOptions(styleID: "PerLevelStyle")
//        poiOption.rank = 0
//
//        // POIs 데이터가 있을 경우 지도에 표시
//        for i in 0..<pois.data.count {
//            let position = layer.addPoi(option: poiOption, at: MapPoint(longitude: pois.data[i].geolocation.longitude, latitude: pois.data[i].geolocation.latitude))
//
//            let badge = PoiBadge(badgeID: pois.data[i].postID, image: UIImage(systemName: "star"), offset: CGPoint(x: 0, y: 0), zOrder: 1)
//
//            print(position, "이것부터")
//            position?.addBadge(badge)
//            position?.show()
//        }
//    }
//
//    override func containerDidResized(_ size: CGSize) {
//        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
//        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
//    }
//
//    var _radius: Float = 20.0
//
//    private var cancellables = Set<AnyCancellable>()
//
//    @Published private var images: [ImageItem] = []
//
//    private var dataSource: UICollectionViewDiffableDataSource<Int, ImageItem>!
//
//    override func loadView() {
//        view = mapView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        configureCollectionView()
//
//        for _ in 0...6 {
//            let imageItem = ImageItem(image: UIImage(systemName: "person")!)
//            images.append(imageItem)
//        }
//    }
//    private func configureCollectionView() {
//        mapView.storyCollectionView.delegate = self
//        mapView.storyCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        mapView.storyCollectionView.showsHorizontalScrollIndicator = false
//
//        dataSource = UICollectionViewDiffableDataSource<Int, ImageItem>(collectionView: mapView.storyCollectionView) { collectionView, indexPath, image in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier, for: indexPath) as! StoryCollectionViewCell
//            cell.configureCell(with: image.image)
//            return cell
//        }
//    }
//
//    override func bind() {
//        $images
//            .receive(on: RunLoop.main)
//            .sink { [weak self] images in
//                var snapshot = NSDiffableDataSourceSnapshot<Int, ImageItem>()
//                snapshot.appendSections([0])
//                snapshot.appendItems(images)
//                self?.dataSource.apply(snapshot, animatingDifferences: true)
//            }
//            .store(in: &cancellables)
//    }
//}


final class MapVC: BaseVC {
    
    //
    //    private let mapView = MapView()
    //
    //    override func loadView() {
    //        view = mapView
    //    }
    private var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMapView()
        setAnnotation()
    }
    
    func setMapView() {
        map = MKMapView(frame: self.view.bounds)
        map.showsUserLocation = true
        view.addSubview(map)
        
        
        // 지도의 중심 좌표와 줌 레벨 설정
        let center = CLLocationCoordinate2D(latitude: 37.7950773, longitude: 128.8966344)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        map.setRegion(region, animated: true)
        
        
        
    }
    
    func setAnnotation() {
        
        Task {
            let geolocationQuery = GeolocationQuery(longitude: "128.90782356262207", latitude: "37.805477856609954", maxDistance: "2000")
            
            do {
                let result = try await NetworkManager2.shared.performRequest(router: .geolocationBasedSearch(query: geolocationQuery), responseType: GeolocationBasedDataModel.self)
                print(result, "🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶")
                for i in 0..<result.data.count {  // `locations`는 GeolocationBasedDataModel 내의 위치 배열이라고 가정합니다.
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: result.data[i].geolocation.latitude, longitude: result.data[i].geolocation.longitude)
                    annotation.title = result.data[i].creator.nick
//                    annotation.subtitle = location.description  // `description`은 위치에 대한 설명
                    
                    map.addAnnotation(annotation)
                }
            } catch {
                print("Error fetching geolocation data: \(error)")
            }
        }
        
    }
}
