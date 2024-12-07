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
    func deleteImage(at index: Int)
}

final class PostDataSourceProvider: PostDataSourceProviderProtocol {
    
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>
    
    enum Section {
        case main
    }
    
    private let collectionView: UICollectionView
    private let btnSize: CGSize
    private var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>!
    var imageList: [UIImage] = []
    
    init(collectionView: UICollectionView, cellSize: CGSize) {
        self.collectionView = collectionView
        self.btnSize = cellSize
        configureDataSource()
    }
    
    
    // 셀 구성
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: collectionView) { [weak self] collectionView, indexPath, image in
            guard let self else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(image: image, btnSize: btnSize)
            
            return cell
        }
        
        applyInitialSnapshot()
    }
    
    // 컬렉션 뷰 적용
    func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // 데이터소스 업데이트
    func updateDataSource(with images: [UIImage]) {
        // 이미지 리스트가 비어 있으면 데이터 소스 초기화
        if images.isEmpty {
            applyInitialSnapshot() // 기존 데이터를 초기화
            return
        }

        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(images)
        imageList = images
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // 데이터 삭제
    func deleteImage(at index: Int) {
        imageList.remove(at: index)
        updateDataSource(with: imageList)
    }
}
