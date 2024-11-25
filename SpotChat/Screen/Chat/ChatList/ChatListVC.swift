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
    
    
    lazy var dataSource: UITableViewDiffableDataSource<Int, OpenChatModel> = {
        UITableViewDiffableDataSource<Int, OpenChatModel>(tableView: chatListView.chatListTableView) { tableView, indexPath, chat in
            
            
            let sender = chat.lastChat?.sender.userID
            
            if sender != UserDefaultsManager.userId {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingListTableViewCell.identifier, for: indexPath) as? ChattingListTableViewCell else { return UITableViewCell() }
                
                cell.configureCell(chat)
                return cell
            }
            
            
            return UITableViewCell()
        }
    }()
    
    
    override func loadView() {
        view = chatListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ChatListVC임 ㅋ.ㅋ")
        print(UserDefaultsManager.userId)
        
    }
    
    override func bind() {
        
        
        let input = chatListVM.input
        let output = chatListVM.transform(input: input)
        
        input.trigger.send(())
        
        output.chattingList
            .receive(on: DispatchQueue.main) // UI 작업은 메인 스레드에서 실행
            .sink { [weak self] chats in
                guard let self = self else { return }
                // DiffableDataSource의 Snapshot 생성 및 적용
                var snapshot = NSDiffableDataSourceSnapshot<Int, OpenChatModel>()
                snapshot.appendSections([0]) // 섹션 추가
                snapshot.appendItems(chats) // 데이터 추가
                dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
        
        chatListView.chatListTableView.didSelectRowPublisher
            .sink { [weak self] indexPath in
                guard let self else { return }
                chatListView.chatListTableView.deselectRow(at: indexPath, animated: true)
            }
            .store(in: &cancellables)
    }
    
}
