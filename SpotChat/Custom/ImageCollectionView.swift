//
//  ImageCollectionView.swift
//  SpotChat
//
//  Created by 최대성 on 11/29/24.
//

import UIKit

final class ImageContainerCollectionView: UICollectionView {
    
    init(itemSize: CGSize, spacing: CGFloat = 8, scrollDirection: UICollectionView.ScrollDirection = .horizontal) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumLineSpacing = spacing
        layout.itemSize = itemSize
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
