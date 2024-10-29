//
//  SignUpVC.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit


final class SignUpVC: BaseVC {
    
    private let signUpView = SignUpView()
    
    override func loadView() {
        view = signUpView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
