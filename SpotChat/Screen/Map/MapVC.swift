//
//  MapVC.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit
import Combine
import CombineCocoa
import KakaoMapsSDK

struct ImageItem: Hashable {
    let id = UUID()
    let image: UIImage
}

final class MapVC: BaseMapVC, UICollectionViewDelegateFlowLayout {
    
    private let mapView = MapView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 128.9072, latitude: 37.7918)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 6)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        createLodLabelLayer()
        
    }
    
    func createLodLabelLayer() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
    
        let custom = LodLabelLayerOptions(layerID: "custom", competitionType: .sameLower, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 5000, radius: _radius)
        
        let _ = manager.addLodLabelLayer(option: custom)
    }
    
    
    override func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
    
    var _radius: Float = 20.0
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var images: [ImageItem] = []
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, ImageItem>!
    
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        configureCollectionView()
        
        for _ in 0...6 {
            let imageItem = ImageItem(image: UIImage(systemName: "person")!)
            images.append(imageItem)
        }
    }
    private func configureCollectionView() {
        mapView.storyCollectionView.delegate = self
        mapView.storyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mapView.storyCollectionView.showsHorizontalScrollIndicator = false
        
        dataSource = UICollectionViewDiffableDataSource<Int, ImageItem>(collectionView: mapView.storyCollectionView) { collectionView, indexPath, image in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier, for: indexPath) as! StoryCollectionViewCell
            cell.configureCell(with: image.image)
            return cell
        }
    }
    
    override func bind() {
        $images
            .receive(on: RunLoop.main)
            .sink { [weak self] images in
                var snapshot = NSDiffableDataSourceSnapshot<Int, ImageItem>()
                snapshot.appendSections([0])
                snapshot.appendItems(images)
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
    }
}
