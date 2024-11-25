//
//  ChatListView.swift
//  SpotChat
//
//  Created by 최대성 on 11/25/24.
//

import UIKit
import SnapKit


final class ChatListView: BaseView {
    
    private let ChatListLabel = {
        let label = UILabel()
        label.text = "채팅"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        
        return label
    }()
    
    let chatListTableView = {
        let view = UITableView()
        view.backgroundColor = .red
        return view
    }()
    
    
    
    override func configureHierarchy() {
        addSubview(ChatListLabel)
        addSubview(chatListTableView)
    }
    
    override func configureLayout() {
        ChatListLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
            make.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        chatListTableView.snp.makeConstraints { make in
            make.top.equalTo(ChatListLabel.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
