//
//  StoryCollectionViewCell.swift
//  SpotChat
//
//  Created by 최대성 on 11/1/24.
//

import UIKit

final class StoryCollectionViewCell: BaseCollectionViewCell {
    
    
    let storyCircleBtn = {
        let btn = UIButton()
        btn.layer.cornerRadius = 35
        btn.backgroundColor = .systemBlue
        return btn
    }()
    private let nicknameLabel = {
        let label = UILabel()
        label.text = "닉네임칸"
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
            make.top.equalTo(storyCircleBtn.snp.bottom).offset(5)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.width.equalTo(100)
        }
    }
    
}
