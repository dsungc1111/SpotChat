//
//  SettingVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/1/24.
//

import Foundation


final class SettingVC: BaseVC {
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
}
