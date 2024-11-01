//
//  SignInView.swift
//  SpotChat
//
//  Created by 최대성 on 11/1/24.
//

import UIKit
import SnapKit

final class SignInView: BaseView {
    
    
    let emailTextField = CustomSignTextField(placeholderText: "이메일을 입력해주세요 :)")
    let passwordTextField = CustomSignTextField(placeholderText: "비밀번호를 입력해주세요 :)")
    
    let signInBtn = {
        let btn = UIButton()
        btn.setTitle("가입하기", for: .normal)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .lightGray
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        return btn
    }()
    
    
    
    override func configureHierarchy() {
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signInBtn)
    }
    override func configureLayout() {
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(100)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        signInBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
}
