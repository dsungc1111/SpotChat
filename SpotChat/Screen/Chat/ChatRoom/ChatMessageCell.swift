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
    
    private let messageBubble: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
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
        backgroundColor = .red
        
        contentView.addSubview(messageBubble)
        messageBubble.addSubview(messageLabel)
        messageBubble.addSubview(imageContainerStackView)
    }
    
    override func configureLayout() {
        
        messageBubble.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.height.greaterThanOrEqualTo(28)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.6)
            make.bottom.equalToSuperview().inset(8).priority(.low)
            
            leadingConstraint = make.leading.equalToSuperview().inset(10).constraint
            trailingConstraint = make.trailing.equalToSuperview().inset(10).constraint
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(messageBubble.snp.top).inset(8)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(imageContainerStackView.snp.top).offset(-8) // 이미지 컨테이너 위에 배치
        }
        
        imageContainerStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 셀의 상태 초기화
        messageLabel.text = nil
        imageContainerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func configureCell(message: Message) {
        // 텍스트 설정
        if let content = message.lastChat.first?.content, !content.isEmpty {
            messageLabel.text = content
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
            
            // 이미지 개수에 따른 스택뷰 구성
            if files.count == 4 {
                // 이미지가 4개일 경우 위아래 2개씩
                for rowIndex in 0..<2 {
                    let horizontalStackView = UIStackView()
                    horizontalStackView.axis = .horizontal
                    horizontalStackView.spacing = 8
                    horizontalStackView.distribution = .fillEqually
                    
                    let startIndex = rowIndex * 2
                    let endIndex = startIndex + 2
                    for fileIndex in startIndex..<endIndex {
                        let imageView = createImageView(urlString: files[fileIndex], processor: processor)
                        horizontalStackView.addArrangedSubview(imageView)
                    }
                    imageContainerStackView.addArrangedSubview(horizontalStackView)
                }
            } else if files.count == 5 {
                // 이미지가 5개일 경우 위 3개, 아래 2개
                let topStackView = UIStackView()
                topStackView.axis = .horizontal
                topStackView.spacing = 8
                topStackView.distribution = .fillEqually
                
                for fileIndex in 0..<3 {
                    let imageView = createImageView(urlString: files[fileIndex], processor: processor)
                    topStackView.addArrangedSubview(imageView)
                }
                
                let bottomStackView = UIStackView()
                bottomStackView.axis = .horizontal
                bottomStackView.spacing = 8
                bottomStackView.distribution = .fillEqually
                
                for fileIndex in 3..<5 {
                    let imageView = createImageView(urlString: files[fileIndex], processor: processor)
                    bottomStackView.addArrangedSubview(imageView)
                }
                
                imageContainerStackView.addArrangedSubview(topStackView)
                imageContainerStackView.addArrangedSubview(bottomStackView)
            } else {
                // 이미지 6장
                let rowCount = Int(ceil(Double(files.count) / 3.0))
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
                }
                
                messageLabel.snp.removeConstraints()
                messageLabel.snp.makeConstraints { make in
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
        } else {
            messageBubble.backgroundColor = AppColorSet.keyColor
            messageLabel.textColor = .black
            trailingConstraint?.deactivate()
            leadingConstraint?.activate()
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
            make.width.height.equalTo(70) // 기본 크기 70x70
        }
        
        // 네트워크 이미지 로드
        if let (url, modifier) = NetworkManager2.shared.fetchProfileImage(imageString: urlString) {
            imageView.kf.setImage(
                with: url,
                options: [
                    .requestModifier(modifier),
                    .processor(processor), // 다운샘플링 처리
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage,
                    .transition(.fade(0.2))
                ]
            )
        } else {
            imageView.image = UIImage(systemName: "person")
        }
        return imageView
    }
}
