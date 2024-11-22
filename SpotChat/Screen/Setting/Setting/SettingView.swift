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
    
    let postCountBtn = UIButton()
    let followersCountBtn = UIButton()
    let followingCountBtn = UIButton()
    
    private let bioLabel =  {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    let editProfileButton = {
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
        setupCountLabel(postCountBtn)
        setupCountLabel(followersCountBtn)
        setupCountLabel(followingCountBtn)
        addSubview(postsCollectionView)
        postsCollectionView.register(UserPostCollectionViewCell.self, forCellWithReuseIdentifier: UserPostCollectionViewCell.identifier)
    }
    
 
    
    private func setupCountLabel(_ btn: UIButton) {
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.textAlignment = .center
//        label.numberOfLines = 2
//        label.font = .systemFont(ofSize: 14)
        addSubview(btn)
    }
    
    
    override func configureLayout() {
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(80)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(8)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        
        postCountBtn.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        followingCountBtn.snp.makeConstraints { make in
            make.top.equalTo(postCountBtn.snp.top)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            make.width.equalTo(80)
        }
        followersCountBtn.snp.makeConstraints { make in
            make.top.equalTo(postCountBtn.snp.top)
            make.leading.equalTo(postCountBtn.snp.trailing).offset(16)
            make.trailing.equalTo(followingCountBtn.snp.leading).offset(-16)
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
        
        postCountBtn.setTitle("\(info.posts.count)\nPosts", for: .normal)
        followersCountBtn.setTitle("\(info.followers.count)\nFollowers", for: .normal)
        followingCountBtn.setTitle("\(info.following.count)\nFollowing", for: .normal)
        
        
        usernameLabel.text = (info.nick ?? "" ).isEmpty ? "아무개" : info.nick
        
        if let profileImage = info.profileImage,
           let (url, modifier) = NetworkManager2.shared.fetchProfileImage(imageString: profileImage) {

            profileImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person"),
                options: [
                    .requestModifier(modifier),
                    .cacheOriginalImage
                ],
                completionHandler: { result in
                    switch result {
                    case .success(let value):
                        print("이미지 로드 성공: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("이미지 로드 실패: \(error.localizedDescription)")
                    }
                }
            )
        }
    }
}
