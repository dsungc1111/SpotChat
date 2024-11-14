//
//  SettingView.swift
//  SpotChat
//
//  Created by 최대성 on 11/14/24.
//

import UIKit
import SnapKit

final class SettingView: BaseView {
    
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let postCountLabel = UILabel()
    private let followersCountLabel = UILabel()
    private let followingCountLabel = UILabel()
    private let bioLabel = UILabel()
    private let editProfileButton = UIButton()
    
    private let postsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutViews() // layoutViews 호출
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayout()
        layoutViews()
    }
    
    override func configureLayout() {
        
        
        // Profile Image
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .lightGray
        addSubview(profileImageView)
        
        // Username Label
        usernameLabel.text = "Username"
        usernameLabel.font = .boldSystemFont(ofSize: 16)
        addSubview(usernameLabel)
        
        // Counts
        setupCountLabel(postCountLabel)
        setupCountLabel(followersCountLabel)
        setupCountLabel(followingCountLabel)
        
        // Bio
        bioLabel.text = "This is the bio section where you can write something about yourself."
        bioLabel.numberOfLines = 0
        bioLabel.font = .systemFont(ofSize: 14)
        addSubview(bioLabel)
        
        // Edit Profile Button
        editProfileButton.setTitle("Edit Profile", for: .normal)
        editProfileButton.setTitleColor(.white, for: .normal)
        editProfileButton.backgroundColor = .black
        editProfileButton.layer.cornerRadius = 5
        addSubview(editProfileButton)
        
        
        // Posts CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.width / 3 - 1, height: frame.width / 3 - 1)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        postsCollectionView.collectionViewLayout = layout
        postsCollectionView.backgroundColor = .white
        addSubview(postsCollectionView)
    }
    
    private func setupCountLabel(_ label: UILabel) {
//        label.text = "\(count)\n\(title)"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        addSubview(label)
    }
    
    private func layoutViews() {
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
    }
}
