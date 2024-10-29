//
//  ViewController.swift
//  SpotChat
//
//  Created by 최대성 on 10/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

/*
 - View는 프로토콜인데 ReactorKit의 View임
 - bind(reactor: )가 View안에 구현되어있음
*/

final class ViewController: UIViewController, View {

    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginBtn = UIButton()
    let resultLabel = UILabel()
//    let aa = NetworkManager()
    let bb = BehaviorSubject(value: ())
    
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        
        self.reactor = LoginReactor()
        bb.onNext(())
        
    }
    
    func bind(reactor: LoginReactor) {
        
        var email = "sesac@gmail.com"
        var password = "adf"
        
        
        // email, pw 텍스트 필드 바인딩
        emailTextField.rx.text.orEmpty
            .map { Reactor.Action.updateEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty
            .map { Reactor.Action.updatePassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        // 로그인 버튼 클릭
        loginBtn.rx.tap
            .map { Reactor.Action.login }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // resultlabel에 email 값 반영
        reactor.state.map { $0.email }
            .bind(with: self, onNext: { owner, value in
                owner.resultLabel.text = value
                email = value
            })
            .disposed(by: disposeBag)
        reactor.state.map { $0.password }
            .bind(with: self) { owner, value in
                password = value
            }
            .disposed(by: disposeBag)
        
        // 버튼 클릭 시, 버튼 타이틀 바뀌게
        reactor.state.map { $0.loginResult }
            .bind(with: self) { owner, btnTitle in
                owner.loginBtn.setTitle(btnTitle, for: .normal)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.btnEnable }
            .bind(with: self) { owner, btnColor in
                owner.loginBtn.backgroundColor = btnColor ? .blue : .red
            }
            .disposed(by: disposeBag)
        
        
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
        
      
       
        
    }
    

    
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

