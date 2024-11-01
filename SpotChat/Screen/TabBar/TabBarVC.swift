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
        print("탭바탭바")
        navigationController?.navigationBar.isHidden = true
        setTabBar()
        
    }
    
    private func setTabBar() {
        
        let mapVC = MapVC()
        let chatVC =  ChatVC()
        let settingVC =  SettingVC()
        
        chatVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        chatVC.tabBarItem.tag = 0
        
        mapVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
        mapVC.tabBarItem.tag = 1
        
        settingVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        settingVC.tabBarItem.tag = 2
        
        setViewControllers([chatVC, mapVC, settingVC], animated: true)
        
        self.tabBar.unselectedItemTintColor = .white
        self.tabBar.tintColor = AppColorSet.keyColor
        self.tabBar.backgroundColor = UIColor(hexCode: "#24242C")
        self.selectedIndex = 1
    }
    
    
}
