//
//  ImageCollectionViewCell.swift
//  SpotChat
//
//  Created by 최대성 on 11/29/24.
//

import UIKit
import SnapKit


final class ImageCollectionViewCell: BaseCollectionViewCell {
    
    private let imageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        btn.tintColor = .red
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(deleteBtn)
    }
    override func configureLayout() {
        layer.cornerRadius = 10
        // 이미지 뷰가 전체 contentView를 차지하도록 설정
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        // 버튼이 contentView 안에 위치하도록 설정
        deleteBtn.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).inset(5)
            make.top.equalTo(contentView.snp.top).inset(5)
            make.size.equalTo(20)
        }
    }
    
    func configureCell(image: UIImage, btnSize: CGSize) {
        imageView.image = image
        deleteBtn.snp.updateConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).inset(5)
            make.top.equalTo(contentView.snp.top).inset(5)
            make.width.equalTo(btnSize.width / 3)
            make.height.equalTo(btnSize.height / 3)
        }
    }
    
}
