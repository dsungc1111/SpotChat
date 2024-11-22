//
//  FollowVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/22/24.
//

import UIKit
import Combine

final class FollowVC: BaseVC {
    
    let followView = FollowView()
    
    private var cancellables = Set<AnyCancellable>()
    
    var followList: [Follow] = [] {
        didSet {
            followView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        view = followView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followView.tableView.dataSource = self
        followView.tableView.delegate = self
    }
    
    override func bind() {
        
        followView.backBtn.tapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables )
        
        followView.FollowSegmentedControl.selectedSegmentIndexPublisher
            .sink { value in
                print(value)
            }
            .store(in: &cancellables)
        
        let list = followList
        
        followView.searchBar.textDidChangePublisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                
                for i in 0..<list.count {
                    if list[i].nick == value {
                        followList = [list[i]]
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    
}

extension FollowVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowTableViewCell.identifier, for: indexPath) as? FollowTableViewCell else { return FollowTableViewCell() }
        
        cell.configureCell(followList[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
