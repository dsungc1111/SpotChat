//
//  ChatRoomView.swift
//  SpotChat
//
//  Created by 최대성 on 11/26/24.
//

import UIKit
import SnapKit

final class ChatRoomView: BaseView {
    
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
    
    private let messageInputContainer = {
        let container = UIView()
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 10
        return container
    }()
    
    let messageTextField = {
        let textField = UITextField()
        textField.placeholder = "메시지를 입력하세요..."
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.returnKeyType = .send
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    let sendButton = {
        let button = UIButton(type: .system)
        button.setTitle("전송", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()
    
    override func configureHierarchy() {
        addSubview(backBtn)
        addSubview(titleLabel)
        addSubview(chatTableView)
        addSubview(messageInputContainer)
        messageInputContainer.addSubview(messageTextField)
        messageInputContainer.addSubview(sendButton)
    }
    
    override func configureLayout() {
        backBtn.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).inset(10)
            make.width.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        chatTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(messageInputContainer.snp.top).offset(-10)
        }
        
        messageInputContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
        
        messageTextField.snp.makeConstraints { make in
            make.leading.equalTo(messageInputContainer).inset(16)
            make.centerY.equalTo(messageInputContainer)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalTo(messageInputContainer).inset(16)
            make.centerY.equalTo(messageInputContainer)
            make.width.equalTo(50)
        }
    }
}
