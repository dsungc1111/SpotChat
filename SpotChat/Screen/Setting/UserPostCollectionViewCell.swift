//
//  UserPostCollectionViewCell.swift
//  SpotChat
//
//  Created by 최대성 on 11/15/24.
//

import UIKit

final class UserPostCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = {
        let image = UIImageView()
        image.backgroundColor = .black
        return image
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
