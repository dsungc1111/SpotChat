//
//  BaseVC.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//


import UIKit

class BaseVC: UIViewController {
    
    
    override func viewDidLoad() {
        print(#function,"네비게이션바 숨겨")
//        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(hexCode: "#2C2929")
        bind()
    }
    
    
    func bind() {}
    
}
