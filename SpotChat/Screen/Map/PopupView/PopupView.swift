//
//  PopupView.swift
//  SpotChat
//
//  Created by 최대성 on 12/1/24.
//

import UIKit
import SnapKit

final class PopupView: UIView {
    
    
    
    
    private let profileImageView =  {
        let view = UIImageView()
        view.layer.cornerRadius = 25
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
        label.text = "바이오 자리"
        return label
    }()
    private let DMBtn = {
        let btn = UIButton()
        btn.setTitle("DM", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btn.backgroundColor = AppColorSet.keyColor
        btn.setTitleColor(AppColorSet.backgroundColor, for: .normal)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    override init(frame: CGRect) {
          super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        backgroundColor = AppColorSet.backgroundColor
        layer.cornerRadius = 10
      }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(bioLabel)
        setupCountLabel(postCountBtn)
        setupCountLabel(followersCountBtn)
        setupCountLabel(followingCountBtn)
        addSubview(DMBtn)
    }
    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(50)
        }
        usernameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.safeAreaLayoutGuide)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        DMBtn.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(profileImageView.safeAreaLayoutGuide)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        postCountBtn.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(12)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        followingCountBtn.snp.makeConstraints { make in
            make.top.equalTo(postCountBtn.snp.top)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.width.equalTo(80)
        }
        followersCountBtn.snp.makeConstraints { make in
            make.top.equalTo(postCountBtn.snp.top)
            make.leading.equalTo(postCountBtn.snp.trailing).offset(16)
            make.trailing.equalTo(followingCountBtn.snp.leading).offset(-16)
        }
    }
    
    private func setupCountLabel(_ btn: UIButton) {
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.textAlignment = .center
        //        label.numberOfLines = 2
        //        label.font = .systemFont(ofSize: 14)
        addSubview(btn)
    }
    
    func configure(profile: ProfileModel) {

        
        
        bioLabel.text = profile.info1 == "" ?  "Not bio yet." : profile.info1
        postCountBtn.setTitle("\(profile.posts.count)\nPosts", for: .normal)
        followersCountBtn.setTitle("\(profile.followers.count)\nFollowers", for: .normal)
        followingCountBtn.setTitle("\(profile.following.count)\nFollowing", for: .normal)
        
        
        usernameLabel.text = (profile.nick ?? "" ).isEmpty ? "아무개" : profile.nick

        if let profileImage = profile.profileImage,
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
