//
//  MapView.swift
//  SpotChat
//
//  Created by 최대성 on 11/1/24.
//

import UIKit
import SnapKit

final class MapView: BaseView {
    
    private let myPinBtn = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "locator"), for: .normal)
        btn.contentMode = .scaleAspectFill
        return btn
    }()
    
    private let searchBar = {
        let search = UISearchBar()
        search.placeholder = "검색하세요."
        search.clipsToBounds = true
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
        let cellSpacing: CGFloat = 10
//        let width = UIScreen.main.bounds.width
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 90, height: 90)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    
    override func configureHierarchy() {
        storyCollectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
        addSubview(myPinBtn)
        addSubview(searchBar)
        addSubview(radiusSetBtn)
        addSubview(storyCollectionView)
    }
    
    override func configureLayout() {
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
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(100)
        }
        storyCollectionView.backgroundColor = .brown
    }

    
    
}
