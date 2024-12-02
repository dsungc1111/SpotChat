//
//  ChatMessageCell.swift
//  SpotChat
//
//  Created by 최대성 on 11/26/24.
//

import UIKit
import SnapKit

final class ChatMessageCell: BaseTableViewCell {
    
    private let messageBubble = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let messageLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private var leadingConstraint: Constraint?
    private var trailingConstraint: Constraint?
    
    private let uploadedImage = {
        let view = UIImageView()
        view.backgroundColor = .systemRed
        view.image = UIImage(systemName: "person")
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        view.contentMode = .scaleAspectFill
        view.isHidden = true
        return view
    }()
    
    private var uploadedImageHeightConstraint: Constraint?
    
    override func configureHierarchy() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(messageBubble)
        messageBubble.addSubview(messageLabel)
        messageBubble.addSubview(uploadedImage)
    }
    
    override func configureLayout() {
        messageBubble.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)
            make.bottom.equalToSuperview().inset(4).priority(.low)
            leadingConstraint = make.leading.equalToSuperview().inset(10).constraint
            trailingConstraint = make.trailing.equalToSuperview().inset(10).constraint
        }
        
        messageLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(12)
        }
        
        uploadedImage.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(5).priority(.required)
            make.leading.trailing.equalToSuperview().inset(8)
            uploadedImageHeightConstraint = make.height.equalTo(60).priority(.required).constraint
            make.bottom.equalToSuperview().inset(8).priority(.low)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        // 셀의 상태 초기화
        messageLabel.text = nil
        uploadedImage.image = nil
        uploadedImage.isHidden = true
        uploadedImageHeightConstraint?.update(offset: 0)
    }
    
    func configureCell(message: Message) {
        if let content = message.lastChat.first?.content, !content.isEmpty {
            messageLabel.text = content
            messageLabel.isHidden = false
        } else {
            messageLabel.text = nil
            messageLabel.isHidden = true
        }
        
        if message.lastChat.first?.files.isEmpty ?? true {
            // 이미지가 없으면 높이 0으로 설정하고 숨김
            uploadedImage.isHidden = true
            uploadedImageHeightConstraint?.update(offset: 0)
        } else {
            // 이미지가 있으면 보이도록 설정
            uploadedImage.isHidden = false
            uploadedImageHeightConstraint?.update(offset: 60)
        }
        
        if messageLabel.isHidden && uploadedImage.isHidden {
            // 텍스트와 이미지가 모두 없으면 버블 숨김
            messageBubble.isHidden = true
        } else {
            messageBubble.isHidden = false
        }

        if message.isSentByUser {
            messageBubble.backgroundColor = UIColor.systemBlue
            messageLabel.textColor = .white
            leadingConstraint?.deactivate()
            trailingConstraint?.activate()
        } else {
            messageBubble.backgroundColor = AppColorSet.keyColor
            messageLabel.textColor = .black
            trailingConstraint?.deactivate()
            leadingConstraint?.activate()
        }
        
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
}
