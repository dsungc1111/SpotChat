//
//  ChatMessageCell.swift
//  SpotChat
//
//  Created by 최대성 on 11/26/24.
//

import UIKit
import SnapKit

final class ChatMessageCell: UITableViewCell {
    
    private let messageBubble = UIView()
    private let messageLabel = UILabel()
    
    private var leadingConstraint: Constraint?
    private var trailingConstraint: Constraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        
        selectionStyle = .none
        backgroundColor = .clear
        
        messageBubble.layer.cornerRadius = 15
        messageBubble.clipsToBounds = true
        
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 16)
        messageBubble.addSubview(messageLabel)
        
        contentView.addSubview(messageBubble)
    }
    
    private func configureLayout() {
        messageBubble.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)
            
            leadingConstraint = make.leading.equalToSuperview().inset(16).constraint
            trailingConstraint = make.trailing.equalToSuperview().inset(16).constraint
        }
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func configureCell(message: Message) {
        messageLabel.text = message.content
        
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
        
        contentView.layoutIfNeeded()
    }
}
