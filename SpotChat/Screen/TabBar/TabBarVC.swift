//
//  TabBarVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/1/24.
//


import UIKit

final class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setTabBar()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(moveToOnBoarding),
                                               name: NSNotification.Name("ExpiredRefreshToken"),
                                               object: nil)
    }
    
    private func setTabBar() {
        
        let postView = PostView()
        let mapVC = MapVC()
        let chatVC =  ChatListVC()
        
        let postVC = PostVC(postView: postView,
                            postVM: PostVM(),
                            bindManager: PostBindingManager(),
                            imagePickerManager: PostImagePickerManager(),
                            dataSourceProvider: PostDataSourceProvider(collectionView: postView.collectionView, cellSize: CGSize(width: 80, height: 80)))
        let settingVC = SettingVC()
        
        chatVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        
        chatVC.tabBarItem.tag = 0
        
        mapVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
        mapVC.tabBarItem.tag = 1
        
        postVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "pencil.tip.crop.circle"), selectedImage: UIImage(systemName: "pencil.tip.crop.circle.fill"))
        postVC.tabBarItem.tag = 2
        
        settingVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        settingVC.tabBarItem.tag = 3
        
        setViewControllers([chatVC, mapVC, postVC, settingVC], animated: true)
        
        self.tabBar.unselectedItemTintColor = .white
        self.tabBar.tintColor = AppColorSet.keyColor
        self.tabBar.backgroundColor = UIColor(hexCode: "#24242C")
        self.selectedIndex = 1
    }
    
    @objc
    private func moveToOnBoarding() {
        
        DispatchQueue.main.async {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let vc = UINavigationController(rootViewController: OnBoardingVC())
            
            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }
}
