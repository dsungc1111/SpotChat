//
//  ChatRoomVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/26/24.
//

import UIKit
import Combine
import CombineCocoa

struct Message {
    let content: String
    let isSentByUser: Bool
}

final class ChatRoomVC: BaseVC {
    
    private var chatRoomView = ChatRoomView()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var messages: [Message] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                chatRoomView.chatTableView.reloadData()
                chatRoomView.messageTextField.text = nil
                scrollToBottom()
            }
            
        }
    }
    
    var list: [OpenChatModel] = []
    
    private lazy var socketManager = SocketNetworkManager(roomID: list.first?.roomID ?? "")
    
    private let chatRoomVM = ChatRoomVM()
    
    override func loadView() {
        view = chatRoomView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        socketManager.connect()
    }
    
    override func bind() {
        
        chatRoomView.backBtn.tapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
        
        chatRoomView.sendButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.sendMessage()
            }
            .store(in: &cancellables)
        
        chatRoomView.titleLabel.text = list.first?.lastChat?.sender.nick
        
        let input = chatRoomVM.input
        let output = chatRoomVM.transform(input: input)
        
        input.trigger.send(list.first?.roomID ?? "")
        
        output.chatList
            .sink { [weak self] chatList in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    // chatList의 각 메시지를 Message 모델로 변환
                    let newMessages = chatList.map { chat in
                        Message(content: chat.content, isSentByUser: chat.sender.userID == UserDefaultsManager.userId )
                    }
                    // messages 배열에 추가
                    self.messages.append(contentsOf: newMessages)
                }
            }
            .store(in: &cancellables)
        
    }
    
    private func configureTableView() {
        chatRoomView.chatTableView.delegate = self
        chatRoomView.chatTableView.dataSource = self
        chatRoomView.chatTableView.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.identifier)
    }
    
    private func sendMessage() {
        guard let text = chatRoomView.messageTextField.text, !text.isEmpty else { return }
        
        let message = Message(content: text, isSentByUser: true)
        messages.append(message)
        
        let sendModel = SocketDMModel(chatID: list.first?.lastChat?.chatID ?? "",
                                      roomID: list.first?.roomID ?? "",
                                      content: text,
                                      createdAt: list.first?.createdAt ?? "",
                                      files: [],
                                      sender: list.first?.lastChat?.sender ?? Sender(userID: "", nick: "", profileImage: ""))
        
        let sendChatModel = SendChatQuery(content: text, files: [])
        Task {
            let result = try await NetworkManager2.shared.performRequest(router: .sendChat(list.first?.roomID ?? "", sendChatModel), responseType: LastChat.self)
            
            print("⚫️⚫️⚫️⚫️⚫️⚫️⚫️⚫️⚫️⚫️⚫️", result)
            
        }
        socketManager.sendMessage(sendModel)
    }
    
    private func scrollToBottom() {
        let lastRowIndex = max(messages.count - 1, 0)
        let indexPath = IndexPath(row: lastRowIndex, section: 0)
        chatRoomView.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension ChatRoomVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as? ChatMessageCell else {
            return UITableViewCell()
        }
        
        let message = messages[indexPath.row]
        cell.configureCell(message: message)
        
        return cell
    }
    
}
