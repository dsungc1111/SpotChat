//
//  ChatVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/1/24.

import UIKit
import Combine
import CombineCocoa


final class ChatListVC: BaseVC {
    
    
    private let chatListView = ChatListView()
    private let chatListVM = ChatListVM()
    private var cancellables = Set<AnyCancellable>()
    
    private var currenChatList: [OpenChatModel] = []
    var participantList: [String] = []
    
    lazy var dataSource: UITableViewDiffableDataSource<Int, OpenChatModel> = {
        UITableViewDiffableDataSource<Int, OpenChatModel>(tableView: chatListView.chatListTableView) { [weak self] tableView, indexPath, chat in
            
            guard let self else { return UITableViewCell()}
            
            for participant in chat.participants {
                if participant.userID != UserDefaultsManager.userId {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingListCell.identifier, for: indexPath) as? ChattingListCell else { return UITableViewCell() }
                    currenChatList.append(chat)
                    cell.configureCell(chat)
                    return cell
                }
            }
            return UITableViewCell()
        }
    }()
    
    
    lazy var input = chatListVM.input
    lazy var output = chatListVM.transform(input: input)
    
    
    override func viewWillAppear(_ animated: Bool) {
        input.trigger.send(())
    }
        
    
    
    override func loadView() {
        view = chatListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func bind() {
        
        
        output.chattingList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chats in
                guard let self = self else { return }
                // DiffableDataSource의 Snapshot 생성 및 적용
                var snapshot = NSDiffableDataSourceSnapshot<Int, OpenChatModel>()
                snapshot.appendSections([0]) // 섹션
                snapshot.appendItems(chats) // 데이터
                dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
        
        chatListView.chatListTableView.didSelectRowPublisher
            .sink { [weak self] indexPath in
                guard let self else { return }
                let vc = ChatRoomVC()
                vc.list = [currenChatList[indexPath.row]]
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                present(vc, animated: true)
                chatListView.chatListTableView.deselectRow(at: indexPath, animated: true)
            }
            .store(in: &cancellables)
    }
}
