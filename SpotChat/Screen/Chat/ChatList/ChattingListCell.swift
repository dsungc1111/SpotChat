//
//  ChattingListTableViewCell.swift
//  SpotChat
//
//  Created by 최대성 on 11/25/24.
//

import UIKit
import SnapKit

final class ChattingListCell: BaseTableViewCell {

    
    private let profileImageView = {
        
        let view = UIImageView()
        let gradientLayer = CAGradientLayer()
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        
        gradientLayer.colors = [UIColor(hexCode: "F4EC78").cgColor, UIColor(hexCode: "6AF4F7").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        gradientLayer.cornerRadius = 30
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 3 // 보더의 두께를 설정
        shapeLayer.path = UIBezierPath(ovalIn: gradientLayer.bounds.insetBy(dx: 2.5, dy: 2.5)).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        
        // 버튼에 그라데이션 레이어 추가
        view.layer.addSublayer(gradientLayer)
        
        return view
    }()
    private let nicknameLabel = {
        let label = UILabel()
        label.text = "닉네임칸"
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    private let contentLabel = {
        let label = UILabel()
        label.text = "마지막 대회에요"
        label.font = .boldSystemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    private let timeLabel = {
        let label = UILabel()
        label.text = "마지막 대화 시간이에요"
        label.font = .boldSystemFont(ofSize: 8)
        return label
    }()
    
    
    override func configureHierarchy() {
        
        addSubview(profileImageView)
        addSubview(nicknameLabel)
        addSubview(contentLabel)
        addSubview(timeLabel)
    }
    
    override func configureLayout() {
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.size.equalTo(60)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
    }
    
    func configureCell(_ chat: OpenChatModel) {
        
        for person in chat.participants {
            if person.userID != UserDefaultsManager.userId {
                nicknameLabel.text = person.nick
                
                if let profileImage = person.profileImage,
                   let (url, modifier) = NetworkManager2.shared.fetchProfileImage(imageString: profileImage) {
                    
                    profileImageView.kf.setImage(
                        with: url,
                        options: [
                            .requestModifier(modifier),
                            .cacheOriginalImage
                        ]
                    )
                } else {
                    profileImageView.image = UIImage(systemName: "person")
                }
                
                contentLabel.text = chat.lastChat?.content
                timeLabel.text = Date.formatDate(from: chat.updatedAt)
                
            }
        }
    }
}
