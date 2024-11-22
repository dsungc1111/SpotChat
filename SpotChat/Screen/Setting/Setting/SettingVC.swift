//
//  SettingVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/1/24.
//

import UIKit
import Combine
import Kingfisher



final class SettingVC: BaseVC {
    
    private let settingView = SettingView()
    
    private let settingVM = SettingVM()
    private var followingList: [Follow] = []
    private var followerList: [Follow] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    var images: [String] = [] {
        didSet {
            settingView.postsCollectionView.reloadData()
        }
    }
    
    override func loadView() {
        view = settingView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            settingView.postsCollectionView.dataSource = self
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func bind() {
        
        let trigger = PassthroughSubject<String, Never>()
        
        
        let input = SettingVM.Input(trigger: trigger)
        
        let output = settingVM.transform(input: input)
        
        
        trigger.send(UserDefaultsManager.userId)
        
        output.myInfoList
            .sink { [weak self] myInfo in
                guard let self else { return }
                followingList = myInfo.following
                followerList = myInfo.followers
                DispatchQueue.main.async {
                    self.settingView.configureView(info: myInfo)
                }
            }
            .store(in: &cancellables)
        
        output.myImageList
            .sink { [weak self] imageList in
                guard let self else { return }

                DispatchQueue.main.async {
                    self.images = imageList
                }
            }
            .store(in: &cancellables)
        
        settingView.editProfileButton.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                let vc = EditUserVC()
                present(vc, animated: true)
            }
            .store(in: &cancellables)
        
        settingView.followersCountBtn.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                
                let vc = FollowVC()
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.followList = followerList
                present(vc, animated: true)
            }
            .store(in: &cancellables)
        
        settingView.followingCountBtn.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                let vc = FollowVC()
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.followList = followingList
                vc.followView.FollowSegmentedControl.selectedSegmentIndex = 1
                present(vc, animated: true)
            }
            .store(in: &cancellables)
        
        
    }
}

extension SettingVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostCollectionViewCell.identifier, for: indexPath) as? UserPostCollectionViewCell else { return UserPostCollectionViewCell() }
        
        
        if let (url, modifier) = NetworkManager2.shared.fetchProfileImage(imageString: images[indexPath.item]) {
            
            cell.imageView.kf.setImage(
                with: url,
                options: [
                    .requestModifier(modifier),
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
            
        }
        return cell
    }
}


