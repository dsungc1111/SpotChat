//
//  TabBarVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/1/24.
//

import UIKit
import SnapKit

final class TabBarVC: UIViewController, UITabBarDelegate {
    
    private let tabBar = UITabBar()
    private var currentViewController: UIViewController?
    
    private let chatVC = ChatListVC()
    private let mapVC = MapVC()
    private let postVC = PostVC(
        postView: PostView(),
        postVM: PostVM(),
        bindManager: PostBindingManager(),
        imagePickerManager: PostImagePickerManager(),
        dataSourceProvider: PostDataSourceProvider(
            collectionView: PostView().collectionView,
            cellSize: CGSize(width: 80, height: 80)
        )
    )
    private let settingVC = SettingVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupInitialViewController()
    }
    
    private func setupTabBar() {
        // UITabBar 설정
        tabBar.delegate = self
        tabBar.items = [
            UITabBarItem(title: nil, image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill")),
            UITabBarItem(title: nil, image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill")),
            UITabBarItem(title: nil, image: UIImage(systemName: "pencil.tip.crop.circle"), selectedImage: UIImage(systemName: "pencil.tip.crop.circle.fill")),
            UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        ]
        tabBar.tintColor = AppColorSet.keyColor
        tabBar.unselectedItemTintColor = .white
        tabBar.backgroundColor = UIColor(hexCode: "#24242C")
        
        view.addSubview(tabBar)
        
        // SnapKit으로 TabBar 레이아웃 설정
        tabBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
    }
    
    private func setupInitialViewController() {
        switchToViewController(mapVC)
        tabBar.selectedItem = tabBar.items?[1]
    }
    
    private func switchToViewController(_ viewController: UIViewController) {
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        
        
        addChild(viewController)
        view.addSubview(viewController.view)
        
        viewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tabBar.snp.top)
        }
        
        viewController.didMove(toParent: self)
        currentViewController = viewController
    }
    
    // MARK: - UITabBarDelegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        switch index {
        case 0:
            switchToViewController(chatVC)
        case 1:
            switchToViewController(mapVC)
        case 2:
            switchToViewController(postVC)
        case 3:
            switchToViewController(settingVC)
        default:
            break
        }
    }
}


//
//
//final class TabBarVC: UITabBarController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationController?.navigationBar.isHidden = true
//        setTabBar()
//        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(moveToOnBoarding),
//                                               name: NSNotification.Name("ExpiredRefreshToken"),
//                                               object: nil)
//    }
//    
//    private func setTabBar() {
//        let postView = PostView()
//        let mapVC = MapVC()
//        let chatVC =  ChatListVC()
//        
//        let postVC = PostVC(postView: postView,
//                            postVM: PostVM(),
//                            bindManager: PostBindingManager(),
//                            imagePickerManager: PostImagePickerManager(),
//                            dataSourceProvider: PostDataSourceProvider(collectionView: postView.collectionView, cellSize: CGSize(width: 80, height: 80)))
//        let settingVC = SettingVC()
//        
//        chatVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
//        
//        chatVC.tabBarItem.tag = 0
//        
//        mapVC.tabBarItem = UITabBarItem(title: "ㅇㄹㅇ", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
//        mapVC.tabBarItem.tag = 1
//        
//        postVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "pencil.tip.crop.circle"), selectedImage: UIImage(systemName: "pencil.tip.crop.circle.fill"))
//        postVC.tabBarItem.tag = 2
//        
//        settingVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
//        settingVC.tabBarItem.tag = 3
//        
//        setViewControllers([chatVC, mapVC, postVC, settingVC], animated: true)
//        
//        
////        self.tabBar.translatesAutoresizingMaskIntoConstraints = false
//        
//        self.tabBar.unselectedItemTintColor = .white
//        self.tabBar.tintColor = AppColorSet.keyColor
//        
//        self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        
//        self.tabBar.backgroundColor = UIColor(hexCode: "#24242C")
//        selectedIndex = 1
//    }
//    
//    
//    
//    @objc
//    private func moveToOnBoarding() {
//        
//        DispatchQueue.main.async {
//            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//            let sceneDelegate = windowScene?.delegate as? SceneDelegate
//            
//            let vc = UINavigationController(rootViewController: OnBoardingVC())
//            
//            sceneDelegate?.window?.rootViewController = vc
//            sceneDelegate?.window?.makeKeyAndVisible()
//        }
//    }
//}
