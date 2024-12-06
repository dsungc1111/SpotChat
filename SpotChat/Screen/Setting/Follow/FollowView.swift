//
//  FollowView.swift
//  SpotChat
//
//  Created by 최대성 on 11/22/24.
//

import UIKit
import SnapKit

final class FollowView: BaseView {
    
    let backBtn = {
       let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        btn.tintColor = .white
        btn.contentHorizontalAlignment = .leading
        return btn
    }()
    private let titleLabel = {
        let label = UILabel()
        label.text = UserDefaultsManager.userNickname
        label.textColor = .white
        return label
    }()
    
    let FollowSegmentedControl = {
        let segment = UISegmentedControl()
        
        segment.insertSegment(withTitle: "Follow", at: 0, animated: true)
        segment.insertSegment(withTitle: "Following", at: 1, animated: true)
        segment.selectedSegmentIndex = 0
        
        return segment
    }()
    let searchBar = {
        let bar = UISearchBar()
        bar.placeholder = "사용자를 검색하세요"
        
        bar.clipsToBounds = true
        bar.searchTextField.borderStyle = .none
        bar.layer.cornerRadius = 20
        return bar
    }()
    
    let tableView = UITableView()
    
    override func configureHierarchy() {
        tableView.register(FollowTableViewCell.self, forCellReuseIdentifier: FollowTableViewCell.identifier)
        addSubview(backBtn)
        addSubview(titleLabel)
        addSubview(FollowSegmentedControl)
        addSubview(searchBar)
        addSubview(tableView)
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
        FollowSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(FollowSegmentedControl.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        tableView.backgroundColor = AppColorSet.backgroundColor
    }
    
}


extension FollowView {
    
    func configureView() {
        
    }
    
}
