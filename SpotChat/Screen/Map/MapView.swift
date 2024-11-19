//
//  MapView.swift
//  SpotChat
//
//  Created by 최대성 on 11/1/24.
//

import UIKit
import SnapKit
import MapKit

final class MapView: BaseView {
    
    var map: MKMapView!
    
    let myPinBtn = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "locator"), for: .normal)
        btn.contentMode = .scaleAspectFill
        return btn
    }()
    
    let searchBar = {
        let search = UISearchBar()
        search.placeholder = "검색하세요."
        search.clipsToBounds = true
        search.searchTextField.borderStyle = .none
        search.layer.cornerRadius = 20
        return search
    }()
    
    
    let radiusSetBtn = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "radius"), for: .normal)
        btn.contentMode = .scaleAspectFill
        return btn
    }()
    
    lazy var storyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: storyCollectionViewLayout())
    
    private func storyCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 10
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 90)
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    
    
    lazy var detailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: detailCollectionViewLayout())
    
    private func detailCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width - 50, height: 120)
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        return layout
    }
    
    
    override func configureHierarchy() {
        map = MKMapView(frame: .zero)
        storyCollectionView.backgroundColor = .clear
        detailCollectionView.backgroundColor = .clear
        storyCollectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
        detailCollectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.identifier)
        storyCollectionView.showsHorizontalScrollIndicator = false
        detailCollectionView.showsHorizontalScrollIndicator = false
        
        addSubview(map)
        backgroundColor = .clear
        addSubview(myPinBtn)
        addSubview(searchBar)
        addSubview(radiusSetBtn)
        addSubview(storyCollectionView)
        addSubview(detailCollectionView)
        map.showsUserLocation = true
    }
    
    override func configureLayout() {
        map.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        myPinBtn.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(24)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
            make.size.equalTo(40)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(60)
            make.height.equalTo(50)
        }
        radiusSetBtn.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(24)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.size.equalTo(40)
        }
        storyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(5)
            make.height.equalTo(140)
        }
        detailCollectionView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(5)
            make.height.equalTo(140)
        }
    }
}
