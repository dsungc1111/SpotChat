//
//  PostDataSourceProvider.swift
//  SpotChat
//
//  Created by 최대성 on 11/5/24.
//

import UIKit


protocol PostDataSourceProviderProtocol {
    
    associatedtype Snapshot
    associatedtype Section
    
    
    func configureDataSource()
    func applyInitialSnapshot()
    func updateDataSource(with images: [UIImage])
    func getCurrentImages() -> [UIImage] 
}

class PostDataSourceProvider: PostDataSourceProviderProtocol {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>
    
    enum Section {
        case main
    }
    
    private let collectionView: UICollectionView
    private var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>!
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        configureDataSource()
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: collectionView) { collectionView, indexPath, image in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            cell.contentView.addSubview(imageView)
            imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
            return cell
        }
        
        // 초기 스냅샷 설정
        applyInitialSnapshot()
    }
    
    func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func updateDataSource(with images: [UIImage]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(images)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func getCurrentImages() -> [UIImage] {
        guard let items = dataSource?.snapshot().itemIdentifiers else { return [] }
        return items
    }
}
