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
        print("세팅뷰")
        
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
                print(Thread.isMainThread)
                DispatchQueue.main.async {
                    self.settingView.configureView(info: myInfo)
                }
            }
            .store(in: &cancellables)
        
        output.myImageList
            .sink { [weak self] imageList in
                guard let self else { return }
                print(imageList.count)
                DispatchQueue.main.async {
                    self.images = imageList
                }
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
                    .transition(.fade(0.2)), // 로드 시 페이드 효과
                    .cacheOriginalImage      // 캐시 저장
                ]
            )
            
        }
        
        return cell
    }
    
    

    
}


