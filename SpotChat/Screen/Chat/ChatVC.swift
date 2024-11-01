//
//  ChatVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/1/24.
//

import UIKit
import Combine
import SnapKit

final class ChatVC: BaseVC {
    
    private var images: [UIImage] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .systemCyan
        view.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        for _ in 0...6 {
            images.append(UIImage(systemName: "person")!)
            images.append(UIImage(systemName: "person")!)
            images.append(UIImage(systemName: "person")!)
            images.append(UIImage(systemName: "person")!)
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setup() {
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(70)
        }
    }
}
extension ChatVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier, for: indexPath) as? StoryCollectionViewCell else { return StoryCollectionViewCell() }
        
        let image = images[indexPath.row]
        cell.storyCircleBtn.setImage(image, for: .normal)
        
        return cell
    }
    
    
}
