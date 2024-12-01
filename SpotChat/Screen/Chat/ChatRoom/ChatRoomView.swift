//
//  ChatRoomView.swift
//  SpotChat
//
//  Created by 최대성 on 11/26/24.
//

import UIKit
import SnapKit

final class ChatRoomView: BaseView {
    
    private let headerContainer = UIView()
    
    let backBtn = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        btn.tintColor = .white
        btn.contentHorizontalAlignment = .center
        return btn
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    let chatTableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80 // 높이 추정값
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    let messageInputContainer = {
        let container = UIView()
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 10
        return container
    }()
    
    let imageContainer = ImageContainerCollectionView(itemSize: CGSize(width: 40, height: 40))
    
    let imageAddBtn = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        btn.tintColor = UIColor.lightGray
        return btn
    }()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        textView.text = "메시지 입력"
        textView.textColor = .lightGray
        textView.backgroundColor = UIColor.systemGray6
        textView.textContainerInset = UIEdgeInsets(top: 7, left: 10, bottom: 5, right: 10)
        return textView
    }()
    
    let sendButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("전송", for: .normal)
        btn.setTitleColor(.systemGray, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btn.isEnabled = false
        return btn
    }()
    
    var messageInputContainerHeightConstraint: Constraint?

    override func configureHierarchy() {
        
        
        
        chatTableView.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.identifier)
        imageContainer.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        addSubview(headerContainer)
        headerContainer.addSubview(backBtn)
        headerContainer.addSubview(titleLabel)
        addSubview(chatTableView)
        addSubview(messageInputContainer)
        messageInputContainer.addSubview(imageContainer)
        messageInputContainer.addSubview(imageAddBtn)
        messageInputContainer.addSubview(messageTextView)
        messageInputContainer.addSubview(sendButton)
    }
    
    override func configureLayout() {
        headerContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        backBtn.snp.makeConstraints { make in
            make.top.leading.equalTo(headerContainer).inset(8)
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerContainer).inset(10)
            make.centerX.equalTo(headerContainer)
        }
        
        chatTableView.snp.makeConstraints { make in
            make.top.equalTo(headerContainer.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(messageInputContainer.snp.top).offset(-10)
        }
        messageInputContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
            self.messageInputContainerHeightConstraint = make.height.equalTo(50).constraint
        }
        imageAddBtn.snp.makeConstraints { make in
            make.leading.equalTo(messageInputContainer).inset(8)
            make.bottom.equalTo(messageInputContainer).inset(15)
            make.size.equalTo(20)
        }
        messageTextView.snp.makeConstraints { make in
            make.top.equalTo(messageInputContainer).inset(8)
            make.leading.equalTo(imageAddBtn.snp.trailing).offset(8)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
        }
        imageContainer.snp.makeConstraints { make in
            make.top.equalTo(messageTextView.snp.bottom)
            make.horizontalEdges.equalTo(messageTextView.snp.horizontalEdges).inset(10)
            make.bottom.equalTo(messageInputContainer.snp.bottom)
        }
        sendButton.snp.makeConstraints { make in
            make.trailing.equalTo(messageInputContainer).inset(10)
            make.bottom.equalTo(messageInputContainer).inset(16)
            make.height.equalTo(20)
            make.width.equalTo(30)
        }
    }
    
    
    func updateMessageInputContainer(forTextView textView: UITextView, hasImages: Bool) {
        let size = CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let estimatedSize = textView.sizeThatFits(size)
        
        // 텍스트뷰와 컬렉션뷰 상태 관리
        if hasImages {
            imageContainer.isHidden = false
            if estimatedSize.height <= 80 {
                textView.isScrollEnabled = false
                messageInputContainerHeightConstraint?.update(offset: max(80, estimatedSize.height + 60)) // 컬렉션뷰 높이 포함
            } else {
                textView.isScrollEnabled = true
            }
        } else {
            imageContainer.isHidden = true
            if estimatedSize.height <= 80 {
                textView.isScrollEnabled = false
                messageInputContainerHeightConstraint?.update(offset: max(50, estimatedSize.height + 16))
            } else {
                textView.isScrollEnabled = true
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    
}
