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
        btn.contentHorizontalAlignment = .leading
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
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    let messageInputContainer = {
        let container = UIView()
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 10
        return container
    }()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        textView.text = "메시지를 입력"
        textView.textColor = .lightGray
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 10)
        return textView
    }()
    
    let sendButton = {
        let button = UIButton(type: .system)
        button.setTitle("전송", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()
    
    override func configureHierarchy() {
        addSubview(headerContainer)
        headerContainer.addSubview(backBtn)
        headerContainer.addSubview(titleLabel)
        addSubview(chatTableView)
        addSubview(messageInputContainer)
        messageInputContainer.addSubview(messageTextView)
        messageInputContainer.addSubview(sendButton)
    }
    
    override func configureLayout() {
        headerContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        
        backBtn.snp.makeConstraints { make in
            make.top.leading.equalTo(headerContainer).inset(10)
            make.height.equalTo(30)
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
            make.height.equalTo(50)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(messageInputContainer).inset(8)
            make.leading.equalTo(messageInputContainer).inset(8)
            make.trailing.equalTo(sendButton.snp.leading).offset(-4)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalTo(messageInputContainer).inset(10)
            make.centerY.equalTo(messageTextView)
            make.width.equalTo(30)
        }
    }
    
}
