//
//  DetailCollectionViewCell.swift
//  SpotChat
//
//  Created by 최대성 on 11/13/24.
//

import UIKit
import SnapKit


final class DetailCollectionViewCell: BaseCollectionViewCell {
    
    
    let userCircleBtn: UIButton = {
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
        
        return btn
    }()
    private let titleLabel = {
        let label = UILabel()
        label.text = "제목칸"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    private let nicknameLabel = {
        let label = UILabel()
        label.text = "닉네임칸"
        label.textColor = .white
        return label
    }()
    private let contentLabel = {
        let label = UILabel()
        label.text = "내용칸"
        label.textColor = .white
        return label
    }()
    private let timeLabel = {
        let label = UILabel()
        label.text = "시간칸"
        return label
    }()
    
    override func configureHierarchy() {
        backgroundColor = .lightGray
        layer.cornerRadius = 10
        contentView.addSubview(userCircleBtn)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(timeLabel)
    }
    override func configureLayout() {
        userCircleBtn.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(userCircleBtn.snp.trailing).offset(10)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo( titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(userCircleBtn.snp.trailing).offset(10)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo( titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.leading.equalTo(userCircleBtn.snp.trailing).offset(10)
        }

        
        
    }
    
    func configureCell(geoModel: PostModel) {
        
        print("0000000", geoModel.content2)
        
        titleLabel.text = geoModel.title
        contentLabel.text = geoModel.content1
        timeLabel.text = geoModel.content2.isEmpty ? "여기는 시간칸" : geoModel.content2
        
        let placeholderImage = UIImage(systemName: "person")
        
        if let profileImage = geoModel.creator.profileImage,
           let (url, modifier) = NetworkManager2.shared.fetchProfileImage(imageString: profileImage) {
            
            userCircleBtn.kf.setImage(
                with: url,
                for: .normal,
                placeholder: placeholderImage,
                options: [
                    .requestModifier(modifier),
                    .cacheOriginalImage
                ]
            )
        } else {
            userCircleBtn.setImage(placeholderImage, for: .normal)
            userCircleBtn.tintColor = .black
        }
    }
}
