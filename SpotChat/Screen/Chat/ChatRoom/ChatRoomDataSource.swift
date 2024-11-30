//
//  ChatRoomDataSource.swift
//  SpotChat
//
//  Created by 최대성 on 11/28/24.
//


import UIKit

final class ChatRoomDataSource: NSObject, UITableViewDataSource {
    
    private var messages: [Message] = []
    
    init(messages: [Message]) {
        self.messages = messages
    }
    
    func updateMessage(message: [Message], tableView: UITableView) {
        self.messages = message
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatMessageCell.identifier, for: indexPath) as? ChatMessageCell else { return UITableViewCell() }
        cell.configureCell(message: messages[indexPath.row])
        return cell
    }
}
