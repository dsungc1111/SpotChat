//
//  MapVC.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit
import Combine
import CombineCocoa



struct ImageItem: Hashable {
    let id = UUID()
    let image: UIImage
}

final class MapVC: BaseVC, UICollectionViewDelegateFlowLayout {
    
    private let mapView = MapView()
    
    
    
    
    
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
