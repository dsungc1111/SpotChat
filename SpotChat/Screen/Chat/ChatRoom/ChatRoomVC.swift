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
    let lastChat: [ChatMessage]
    let isSentByUser: Bool
}

final class ChatRoomVC: BaseVC {
    
    private var chatRoomView = ChatRoomView()
    private var cancellables = Set<AnyCancellable>()
    private var imagePicker = PostImagePickerManager()
    
    private lazy var dataSourceProvider = PostDataSourceProvider(collectionView: chatRoomView.imageContainer, cellSize: CGSize(width: 40, height: 40))
    
    private var uploadImageList: [UIImage] = []
    
    private var messages: [Message] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                print(messages.count)
                dataSource.updateMessage(message: messages, tableView: chatRoomView.chatTableView)
                scrollToBottom()
            }
        }
    }
    
    private var dataSource: ChatRoomDataSource!
    
    var list: [OpenChatModel] = []
    
    var navigationTitle: String = ""
    
    private lazy var chatRoomVM = ChatRoomVM(socketManager: SocketNetworkManager(roomID: list.first?.roomID ?? ""))
    
    override func loadView() {
        view = chatRoomView
    }
    override func viewDidDisappear(_ animated: Bool) {
        KeyboardManager.shared.removeObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupKeyboardManager()
    }
    
    
    override func bind() {
        
        let input = chatRoomVM.input
        let output = chatRoomVM.transform(input: input)
        
        input.trigger.send(list.first?.roomID ?? "")
        
        output.chatList
            .sink { [weak self] chatList in
                guard let self else { return }
                
                // chatList는 [ChatMessage]이므로 map을 바로 호출
                let newMessages = chatList.map {
                    Message(lastChat: [$0], isSentByUser: $0.sender?.userID == UserDefaultsManager.userId)
                }
                
                messages.append(contentsOf: newMessages)
            }
            .store(in: &cancellables)
        
        
        // 전송 버튼
        chatRoomView.sendButton.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                guard let text = chatRoomView.messageTextView.text else { return }
                
                
                let sendModel = SocketDMModel(chatID: list.first?.lastChat?.chatID ?? "",
                                              roomID: list.first?.roomID ?? "",
                                              content: text,
                                              createdAt: list.first?.createdAt ?? "",
                                              files: [],
                                              sender: list.first?.lastChat?.sender ?? Sender(userID: "", nick: "", profileImage: "")
                )
                
                // 이미지 리스트 초기화
                uploadImageList = []
                dataSourceProvider.updateDataSource(with: uploadImageList)
                
                // 텍스트뷰 초기화
                chatRoomView.messageTextView.text = ""
                chatRoomView.messageTextView.textColor = .lightGray
                chatRoomView.messageTextView.isScrollEnabled = false
                
                // 메시지 입력 컨테이너 높이 초기화
                chatRoomView.messageInputContainerHeightConstraint?.update(offset: 50)
                
                // 전송 버튼 상태 초기화
                chatRoomView.sendButton.setTitleColor(.lightGray, for: .normal)
                chatRoomView.sendButton.isEnabled = false
                
                UIView.animate(withDuration: 0.3) {
                    self.chatRoomView.layoutIfNeeded()
                }
                input.sendMessage.send(sendModel)
                
            }
            .store(in: &cancellables)
        
        // 이미지 픽
        imagePicker.finishImagePick = { [weak self] images in
            guard let self else { return }
            dataSourceProvider.updateDataSource(with: images)
            uploadImageList = images
            let hasImages = !images.isEmpty
            chatRoomView.updateMessageInputContainer(forTextView: self.chatRoomView.messageTextView, hasImages: hasImages)
            
            let imageDataList = images.compactMap { $0.jpegData(compressionQuality: 0.1)}
            input.imageDataList.send(imageDataList)
            
            if uploadImageList.count != 0 {
                chatRoomView.sendButton.isEnabled = true
                chatRoomView.sendButton.setTitleColor(.systemBlue, for: .normal)
            }
        }
        
        
        chatRoomView.backBtn.tapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
        
        chatRoomView.imageAddBtn.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                imagePicker.openGallery(in: self)
            }
            .store(in: &cancellables)
        
        for other in list[0].participants {
            if other.userID != UserDefaultsManager.userId {
                navigationTitle = other.nick
            }
        }
        
        chatRoomView.titleLabel.text = navigationTitle
    }
    
    
    private func configureTableView() {
        dataSource = ChatRoomDataSource(messages: messages)
        chatRoomView.messageTextView.delegate = self
        chatRoomView.chatTableView.delegate = self
        chatRoomView.chatTableView.dataSource = dataSource
        chatRoomView.imageContainer.delegate = self
    }
    
    // 메시지가 있을 때만
    private func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let lastRowIndex = max(messages.count - 1, 0)
        let indexPath = IndexPath(row: lastRowIndex, section: 0)
        chatRoomView.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - 키보드 대응
extension ChatRoomVC {
    
    private func setupKeyboardManager() {
        KeyboardManager.shared.configure(
            observingView: view,
            keyboardWillShow: { [weak self] keyboardHeight in
                guard let self else { return }
                updateMessageInputPosition(for: keyboardHeight)
            },
            keyboardWillHide: { [weak self] in
                guard let self else { return }
                resetMessageInputPosition()
            },
            dismissOnTap: true
        )
    }
    
    private func updateMessageInputPosition(for keyboardHeight: CGFloat) {
        chatRoomView.messageInputContainer.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-keyboardHeight)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func resetMessageInputPosition() {
        chatRoomView.messageInputContainer.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextView
extension ChatRoomVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "메시지 입력" && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .white
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != "메시지 입력" && !textView.text.isEmpty {
            chatRoomView.sendButton.setTitleColor(.systemBlue, for: .normal)
            chatRoomView.sendButton.isEnabled = true
        } else {
            chatRoomView.sendButton.setTitleColor(.lightGray, for: .normal)
            chatRoomView.sendButton.isEnabled = false
        }
        let hasImages = !dataSourceProvider.imageList.isEmpty
        chatRoomView.updateMessageInputContainer(forTextView: textView, hasImages: hasImages)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .lightGray
        }
    }
}

extension ChatRoomVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSourceProvider.deleteImage(at: indexPath.row)
        let hasImages = !dataSourceProvider.imageList.isEmpty
        chatRoomView.updateMessageInputContainer(forTextView: chatRoomView.messageTextView, hasImages: hasImages)
    }
}

extension ChatRoomVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        chatRoomVM.fetchMoreChatsIfNeeded(for: list.first?.roomID ?? "", currentIndex: indexPath.row)
    }
}
