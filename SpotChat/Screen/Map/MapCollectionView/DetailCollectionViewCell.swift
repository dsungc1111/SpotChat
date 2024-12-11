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
        /*
         gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
         gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
         gradientLayer.frame = CGRect(x: -1, y: -1, width: 62, height: 62)
         gradientLayer.cornerRadius = 31
         */
        
        gradientLayer.colors = [UIColor(hexCode: "F4EC78").cgColor, UIColor(hexCode: "6AF4F7").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: -1, y: -1, width: 72, height: 72)
        gradientLayer.cornerRadius = 36
        
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
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    private let contentLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    private let DMLabel = {
        let label = UILabel()
        label.text = "DM"
        label.backgroundColor = AppColorSet.backgroundColor
        label.textColor = AppColorSet.backgroundColor
        label.font = .boldSystemFont(ofSize: 12)
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    private let JoinLabel = {
        let label = UILabel()
        label.text = "Join"
        label.backgroundColor = AppColorSet.backgroundColor
        label.textColor = AppColorSet.backgroundColor
        label.font = .boldSystemFont(ofSize: 12)
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    private let timeLabel = {
        let label = UILabel()
        label.text = "시간칸"
        label.font = .systemFont(ofSize: 8)
        return label
    }()
    private let distanceLabel = {
        let label = UILabel()
        
        return label
    }()
    
    override func configureHierarchy() {
        backgroundColor = AppColorSet.backgroundColor
        layer.cornerRadius = 20
        contentView.addSubview(userCircleBtn)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(DMLabel)
        contentView.addSubview(JoinLabel)
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
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(userCircleBtn.snp.trailing).offset(10)
        }
       
        DMLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(70)
            make.width.equalTo(30)
        }
        JoinLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            make.width.equalTo(30)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.leading.equalTo(userCircleBtn.snp.trailing).offset(10)
            make.trailing.equalTo(JoinLabel.snp.trailing)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.leading.equalTo(userCircleBtn.snp.trailing).offset(10)
        }
    }
    
    func configureCell(geoModel: PostModel) {
        
        titleLabel.text = geoModel.title
        contentLabel.text = geoModel.content1
        timeLabel.text = "10분 전"
        print("11111111", geoModel)
        nicknameLabel.text = "작성자: jinha"
        
        
        if let (url, modifier) = NetworkManager2.shared.fetchProfileImage(imageString: "uploads/profiles/1733464237691.jpg") {
            
            userCircleBtn.kf.setImage(
                with: url,
                for: .normal,
                options: [
                    .requestModifier(modifier),
                    .cacheOriginalImage
                ]
            )
            userCircleBtn.clipsToBounds = true
        } else {
            userCircleBtn.setImage(UIImage(systemName: "person"), for: .normal)
            userCircleBtn.tintColor = .black
        }
        
        if geoModel.content3 == "on" {
            DMLabel.backgroundColor = AppColorSet.keyColor
            DMLabel.textColor = AppColorSet.backgroundColor
        }
        if geoModel.content3 == "on" {
            JoinLabel.backgroundColor = AppColorSet.keyColor
            JoinLabel.textColor = AppColorSet.backgroundColor
        }
        
        
        
    }
}
