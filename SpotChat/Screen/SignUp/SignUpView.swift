//
//  SignUpView.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit

final class SignUpView: BaseView {
    
    private let titleLabel = {
       let label = UILabel()
        label.text = "회원가입"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let emailTextField = CustomSignTextField(placeholderText: "이메일을 입력해주세요 :)")
    let emailValidBtn = {
        let btn = UIButton()
        btn.setTitle("중복 확인", for: .normal)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .lightGray
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return btn
    }()
    
    let passwordTextField = CustomSignTextField(placeholderText: "비밀번호를 입력해주세요 :)")
    let passwordCheckTextField = CustomSignTextField(placeholderText: "비밀번호를 한 번 더 입력해주세요 :)")
    
    let nicknameTextField = CustomSignTextField(placeholderText: "닉네임을 입력해주세요 :)")
    
    let phoneNumberTextfield = CustomSignTextField(placeholderText: "전화번호를 입력해주세요")
    
    let signInBtn = {
        let btn = UIButton()
        btn.setTitle("가입하기", for: .normal)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .lightGray
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        return btn
    }()
    
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(emailTextField)
        addSubview(emailValidBtn)
        addSubview(passwordTextField)
        addSubview(passwordCheckTextField)
        addSubview(nicknameTextField)
        addSubview(phoneNumberTextfield)
        addSubview(signInBtn)
        
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(100)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(100)
        }
        emailValidBtn.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(100)
            make.leading.equalTo(emailTextField.snp.trailing).offset(10)
            make.height.equalTo(50)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        passwordCheckTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        phoneNumberTextfield.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        
        
        signInBtn.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(60)
            make.height.equalTo(50)
        }
        
      
        
    }
    
}
