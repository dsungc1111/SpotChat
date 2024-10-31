//
//  AuthView.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit
import SnapKit
import AuthenticationServices


final class AuthView: BaseView {
    
    let appleLoginBtn =  ASAuthorizationAppleIDButton(type: .signIn, style: .white)
    
    let kakaoLoginBtn = {
        let btn = UIButton()
        btn.setTitle("카카오로 계속하기", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .systemYellow
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = .boldSystemFont(ofSize: 17)
        return btn
    }()
    
    let emailLoginBtn = {
        let btn = UIButton()
        btn.setTitle("이메일로 계속하기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemGreen
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = .boldSystemFont(ofSize: 17)
        return btn
    }()
    
    let signinBtn = {
        let btn = UIButton()
        btn.setTitle("또는 새롭게 회원가입 하기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 17)
        return btn
    }()
    
    override func configureHierarchy() {
        addSubview(appleLoginBtn)
        addSubview(kakaoLoginBtn)
        addSubview(emailLoginBtn)
        addSubview(signinBtn)
    }
    override func configureLayout() {
        appleLoginBtn.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        kakaoLoginBtn.snp.makeConstraints { make in
            make.top.equalTo(appleLoginBtn.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        emailLoginBtn.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginBtn.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        signinBtn.snp.makeConstraints { make in
            make.top.equalTo(emailLoginBtn.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
}
