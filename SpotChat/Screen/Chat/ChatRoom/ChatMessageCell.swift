//
//  ChatMessageCell.swift
//  SpotChat
//
//  Created by 최대성 on 11/26/24.
//

import UIKit
import SnapKit
import Kingfisher

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
    
    private let timeLabel = {
        let label = UILabel()
        label.text = "시가닝요"
        label.font = .systemFont(ofSize: 8)
        label.textColor = .white
        return label
    }()
    
    private var leadingConstraint: Constraint?
    private var trailingConstraint: Constraint?
    
    private var imageContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    override func configureHierarchy() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(messageBubble)
        messageBubble.addSubview(messageLabel)
        messageBubble.addSubview(imageContainerStackView)
        contentView.addSubview(timeLabel)
    }
    
    override func configureLayout() {
        messageBubble.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.6)
            make.bottom.equalToSuperview().inset(8).priority(.low)
            
            leadingConstraint = make.leading.equalToSuperview().inset(10).constraint
            trailingConstraint = make.trailing.equalToSuperview().inset(10).constraint
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(messageBubble.snp.top).inset(8)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(imageContainerStackView.snp.top).offset(-8)
        }
        imageContainerStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(16)
        }
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(messageBubble.snp.bottom)
            make.leading.equalTo(messageBubble.snp.trailing).offset(4).priority(.medium)
            make.trailing.equalTo(messageBubble.snp.leading).offset(-4).priority(.medium)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        messageLabel.isHidden = false
        imageContainerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        imageContainerStackView.isHidden = true
    }
    
    func configureCell(message: Message) {
        // 텍스트 설정
        if let content = message.lastChat.first?.content, !content.isEmpty {
            messageLabel.text = content
            timeLabel.text = Date.formatDate(from: message.lastChat[0].createdAt)
            messageLabel.isHidden = false
            
        } else {
            messageLabel.text = nil
            messageLabel.isHidden = true
        }
        
        // 이미지 설정
        if let files = message.lastChat.first?.files, !files.isEmpty {
            imageContainerStackView.isHidden = false
            imageContainerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            let targetSize = CGSize(width: 70, height: 70)
            let processor = DownsamplingImageProcessor(size: targetSize)
            
            let rowCount = Int(ceil(Double(files.count) / 3.0)) // 3개씩 행 생성
            for rowIndex in 0..<rowCount {
                let horizontalStackView = UIStackView()
                horizontalStackView.axis = .horizontal
                horizontalStackView.spacing = 8
                horizontalStackView.distribution = .fillEqually
                
                let startIndex = rowIndex * 3
                let endIndex = min(startIndex + 3, files.count)
                for fileIndex in startIndex..<endIndex {
                    let imageView = createImageView(urlString: files[fileIndex], processor: processor)
                    horizontalStackView.addArrangedSubview(imageView)
                }
                imageContainerStackView.addArrangedSubview(horizontalStackView)
                
                
                messageLabel.snp.remakeConstraints { make in
                    make.top.equalTo(messageBubble.snp.top).inset(8)
                    make.leading.trailing.equalToSuperview().inset(12)
                    make.bottom.equalTo(imageContainerStackView.snp.top).offset(-8)
                }
            }
        } else {
            messageLabel.snp.remakeConstraints { make in
                make.top.equalTo(messageBubble.snp.top).inset(8)
                make.leading.trailing.equalToSuperview().inset(12)
                make.bottom.equalToSuperview().inset(8)
            }
            imageContainerStackView.isHidden = true
        }
        
        // 텍스트와 이미지가 모두 없으면 버블 숨김
        messageBubble.isHidden = messageLabel.isHidden && imageContainerStackView.isHidden ? true : false
        
        // 메시지 방향 설정
        if message.isSentByUser {
            messageBubble.backgroundColor = AppColorSet.skyblue
            messageLabel.textColor = .black
            leadingConstraint?.deactivate()
            trailingConstraint?.activate()
            
            timeLabel.snp.remakeConstraints { make in
                make.trailing.equalTo(messageBubble.snp.leading).offset(-4)
                make.bottom.equalTo(messageBubble.snp.bottom).inset(4)
                
            }
        } else {
            messageBubble.backgroundColor = AppColorSet.keyColor
            messageLabel.textColor = .black
            trailingConstraint?.deactivate()
            leadingConstraint?.activate()
            
            timeLabel.snp.remakeConstraints { make in
                make.leading.equalTo(messageBubble.snp.trailing).offset(4)
                make.bottom.equalTo(messageBubble.snp.bottom).inset(4)
            }
        }
        
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    private func createImageView(urlString: String, processor: DownsamplingImageProcessor) -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(70)
        }
        
        if let (url, modifier) = NetworkManager2.shared.fetchProfileImage(imageString: urlString) {
            imageView.kf.setImage(
                with: url,
                options: [
                    .requestModifier(modifier),
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheMemoryOnly, // 메모리 캐시만 사용
                    .transition(.fade(0.2))
                ]
            )
        } else {
            imageView.image = UIImage(systemName: "person")
        }
        return imageView
    }
}
