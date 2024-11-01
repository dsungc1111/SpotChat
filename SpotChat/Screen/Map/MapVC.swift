//
//  MapVC.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit
import Combine
import CombineCocoa

final class MapVC: BaseVC, UICollectionViewDelegateFlowLayout {
    
    private let mapView = MapView()
    private var cancellables = Set<AnyCancellable>()
    
    private var datasource: UICollectionViewDiffableDataSource<Int, [Int]>!
    
    @Published private var story = [1, 2, 3, 4, 5]
    
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        bindStoryToCollectionView()
    }
    
    private func bindStoryToCollectionView() {
        // story 배열의 변경 사항을 구독하여 collection view의 데이터를 리로드
        $story
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.mapView.storyCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}
