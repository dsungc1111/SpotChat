//
//  StoryCollectionViewCell.swift
//  SpotChat
//
//  Created by 최대성 on 11/1/24.
//

import UIKit
import SnapKit
import Kingfisher

final class StoryCollectionViewCell: BaseCollectionViewCell {
    
    
    private let storyCircleBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 35
        btn.backgroundColor = .systemGray
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColor(hexCode: "F4EC78").cgColor, UIColor(hexCode: "6AF4F7").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        gradientLayer.cornerRadius = 35
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 3 // 보더의 두께를 설정
        shapeLayer.path = UIBezierPath(ovalIn: gradientLayer.bounds.insetBy(dx: 2.5, dy: 2.5)).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        
        // 버튼에 그라데이션 레이어 추가
        btn.layer.addSublayer(gradientLayer)
        btn.clipsToBounds = true
        
        return btn
    }()
    
    private let nicknameLabel = {
        let label = UILabel()
        label.text = "닉네임칸"
        label.textColor = .white
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(storyCircleBtn)
        contentView.addSubview(nicknameLabel)
    }
    override func configureLayout() {
        storyCircleBtn.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(storyCircleBtn.snp.bottom).offset(10)
            make.centerX.equalTo(safeAreaLayoutGuide)
            
        }
    }
    func configureCell(following: Follow) {
        
        
        
        storyCircleBtn.setImage(following.profileImage == nil ? UIImage(systemName: "person") : UIImage(systemName: "star"), for: .normal)
        
        
        let placeholderImage = UIImage(systemName: "person")
        storyCircleBtn.setImage(placeholderImage, for: .normal)
        
        
        nicknameLabel.text = following.nick
        
        if let profileImage = following.profileImage,
           let (url, modifier) = NetworkManager2.shared.fetchProfileImage(imageString: profileImage) {
            
            storyCircleBtn.kf.setImage(
                with: url,
                for: .normal,
                placeholder: placeholderImage,
                options: [
                    .requestModifier(modifier),
                    .cacheOriginalImage
                ]
            )
        }
    }
}
