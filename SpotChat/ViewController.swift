//
//  ViewController.swift
//  SpotChat
//
//  Created by 최대성 on 10/24/24.
//

import UIKit
import SnapKit
//import RxSwift
//import RxCocoa


final class ViewController: UIViewController {

    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginBtn = UIButton()
    let resultLabel = UILabel()
//    let aa = NetworkManager()
//    let bb = BehaviorSubject(value: ())
//    
//    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        
        
//        bb.onNext(())
        
    }
    
  
//        aa.requestCall(router: .ValidEmail(query: "111@gmail.com"), type: EmailValidationModel.self)
        
        
//        let emailQuery = EmailValidationQuery(email: "1111@google.com")
//        let loginQuery = SigninQuery(email: "1111@google.com", password: "11111111", nick: "펭귄", phoneNum: "01011112222", birthDay: "20000101", gender: "male", info1: "1", info2: "2", info3: "3", info4: "4", info5: "5")
//        
    
//        NetworkManager.shared.performRequest(router: .Signin(query: loginQuery), responseType: SigninModel.self) { result in
//            switch result {
//                case .success(let response):
//                    print("Success: \(response)")
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//        }
        
    func configureHierarchy() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginBtn)
        view.addSubview(resultLabel)
    }
    
    func configureLayout() {
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        emailTextField.placeholder = "이메일"
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        passwordTextField.placeholder = "비번"
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(60)
            make.height.equalTo(50)
        }
        loginBtn.setTitle("버튼임", for: .normal)
        loginBtn.backgroundColor = .systemBlue
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(loginBtn.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(20)
        }
        resultLabel.text = "대기중"
    }

}

