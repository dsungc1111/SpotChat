//
//  ChatRoomVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/26/24.
//

import UIKit
import Combine
import CombineCocoa
import IQKeyboardManagerSwift

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
                guard let self = self else { return }
                self.chatRoomView.chatTableView.reloadData()
                self.scrollToBottom()
            }
        }
    }

    var list: [OpenChatModel] = []
    private lazy var socketManager = SocketNetworkManager(roomID: list.first?.roomID ?? "")
    private let chatRoomVM = ChatRoomVM()

    override func loadView() {
        view = chatRoomView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        setupKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        socketManager.connect()
        chatRoomView.messageTextView.delegate = self 
    }

    override func bind() {
        chatRoomView.backBtn.tapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)

        chatRoomView.sendButton.tapPublisher
            .sink { [weak self] _ in
                self?.sendMessage()
            }
            .store(in: &cancellables)

        chatRoomView.titleLabel.text = "채팅방"

        let input = chatRoomVM.input
        let output = chatRoomVM.transform(input: input)

        input.trigger.send(list.first?.roomID ?? "")

        output.chatList
            .sink { [weak self] chatList in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    let newMessages = chatList.map {
                        Message(content: $0.content, isSentByUser: $0.sender.userID == UserDefaultsManager.userId)
                    }
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
        guard let text = chatRoomView.messageTextView.text, !text.isEmpty, text != "메시지를 입력하세요..." else { return }
        
        let message = Message(content: text, isSentByUser: true)
        messages.append(message)
        
        let sendModel = SocketDMModel(chatID: list.first?.lastChat?.chatID ?? "",
                                      roomID: list.first?.roomID ?? "",
                                      content: text,
                                      createdAt: list.first?.createdAt ?? "",
                                      files: [],
                                      sender: list.first?.lastChat?.sender ?? Sender(userID: "", nick: "", profileImage: "")
        )

        let sendChatModel = SendChatQuery(content: text, files: [])
        Task {
            do {
                let result = try await NetworkManager2.shared.performRequest(
                    router: .sendChat(list.first?.roomID ?? "", sendChatModel),
                    responseType: LastChat.self
                )
                print("⚫️ 메시지 전송 성공: \(result)")
            } catch {
                print("🔴 메시지 전송 실패: \(error)")
            }
        }
        
        socketManager.sendMessage(sendModel)
        chatRoomView.messageTextView.text = ""
    }

    private func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let lastRowIndex = max(messages.count - 1, 0)
        let indexPath = IndexPath(row: lastRowIndex, section: 0)
        chatRoomView.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - 키보드 대응
extension ChatRoomVC {
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        // 현재 동작하고 있는 이벤트에서 키보드의 frame을 받아옴
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        //현재 기기의 안전 영역(Safe Area) 하단에 있는 공간 크기입니다.
        let safeAreaBottomInset = view.safeAreaInsets.bottom
        
        let adjustedHeight = keyboardHeight - safeAreaBottomInset
        
        // 입력창 컨테이너 이동
        chatRoomView.messageInputContainer.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-adjustedHeight)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        scrollToBottom()
    }

    @objc private func keyboardWillHide(notification: Notification) {
        // 입력창 컨테이너 복구
        chatRoomView.messageInputContainer.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - TableView Delegate & DataSource
extension ChatRoomVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatMessageCell.identifier, for: indexPath) as? ChatMessageCell else {
            return UITableViewCell()
        }
        
        let message = messages[indexPath.row]
        cell.configureCell(message: message)
        return cell
    }
}

extension ChatRoomVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "메시지를 입력" && textView.textColor == .lightGray {
            textView.text = "" // 텍스트를 비움
            textView.textColor = .white // 텍스트 색상 변경
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // 텍스트뷰 높이를 동적으로 변경
        let size = CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let estimatedSize = textView.sizeThatFits(size)
        
        chatRoomView.messageInputContainer.snp.updateConstraints { make in
            make.height.equalTo(max(50, estimatedSize.height + 10)) // 최소 높이 50
        }
                         
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // 텍스트뷰가 비어 있는 경우 기본 텍스트를 복원
        if textView.text.isEmpty {
            textView.text = "메시지를 입력하세요..."
            textView.textColor = .lightGray
        }
    }
}
