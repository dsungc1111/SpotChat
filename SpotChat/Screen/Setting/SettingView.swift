//
//  SettingView.swift
//  SpotChat
//
//  Created by 최대성 on 11/14/24.
//

import UIKit
import SnapKit
import Kingfisher

final class SettingView: BaseView {
    
    private let profileImageView =  {
        let view = UIImageView()
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let usernameLabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let postCountLabel = UILabel()
    private let followersCountLabel = UILabel()
    private let followingCountLabel = UILabel()
    
    private let bioLabel =  {
        let label = UILabel()
        label.text = "This is the bio section where you can write something about yourself."
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let editProfileButton = {
        let btn = UIButton()
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 5
        
        return btn
    }()
    
    
    lazy var postsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: postsCollectionViewLayout())
    
    private func postsCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let spacing: CGFloat = 1 // 셀 간의 간격
        let numberOfItemsPerRow: CGFloat = 3
        let totalSpacing = spacing * (numberOfItemsPerRow - 1)
        
        let itemWidth = (width - totalSpacing) / numberOfItemsPerRow
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: floor(itemWidth), height: floor(itemWidth))
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        return layout
    }
    
    override func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(bioLabel)
        addSubview(editProfileButton)
        setupCountLabel(postCountLabel)
        setupCountLabel(followersCountLabel)
        setupCountLabel(followingCountLabel)
        addSubview(postsCollectionView)
        postsCollectionView.register(UserPostCollectionViewCell.self, forCellWithReuseIdentifier: UserPostCollectionViewCell.identifier)
    }
    
 
    
    private func setupCountLabel(_ label: UILabel) {
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        addSubview(label)
    }
    
    
    override func configureLayout() {
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(80)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        
        postCountLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(8)
            make.leading.equalTo(usernameLabel.snp.leading)
        }
        
        followersCountLabel.snp.makeConstraints { make in
            make.top.equalTo(postCountLabel.snp.top)
            make.leading.equalTo(postCountLabel.snp.trailing).offset(16)
        }
        
        followingCountLabel.snp.makeConstraints { make in
            make.top.equalTo(postCountLabel.snp.top)
            make.leading.equalTo(followersCountLabel.snp.trailing).offset(16)
        }
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(36)
        }
        postsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(editProfileButton.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureView(info: ProfileModel) {
        bioLabel.text = info.info1
        
        postCountLabel.text = "\(info.posts.count)\nPosts"
        followersCountLabel.text = "\(info.followers.count)\nFollowers"
        followingCountLabel.text = "\(info.following.count)\nFollowing"
        
        usernameLabel.text = (info.nick ?? "" ).isEmpty ? "아무개" : info.nick
        
        profileImageView.image = info.profileImage == nil ? UIImage(systemName: "person") : UIImage(systemName: "star")
        
    }
}
