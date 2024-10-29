//
//  OnBoardingVC.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit
import RxSwift
import RxCocoa

final class OnBoardingVC: BaseVC {
 
    
    private let onBoardingView = OnBoardingView()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = onBoardingView
    }
    override func viewIsAppearing(_ animated: Bool) {
        loadSignInView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func bind() {
        
        onBoardingView.loginBtn.rx.tap
            .bind(with: self) { owner, _ in
                owner.loadSignInView()
            }
            .disposed(by: disposeBag)
        
    }
    
    
    private func loadSignInView() {
        
        let vc = AuthVC()
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [
                .custom { _ in
                    return 250
                }
            ]
            sheet.prefersGrabberVisible = true
        }
        
        self.present(vc, animated: true)
    }
}


