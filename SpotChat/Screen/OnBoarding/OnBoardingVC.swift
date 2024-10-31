//
//  OnBoardingVC.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit
import Combine
import CombineCocoa

final class OnBoardingVC: BaseVC {
 
    
    private let onBoardingView = OnBoardingView()
    private var cancellables = Set<AnyCancellable>()
    
    
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
       
        onBoardingView.loginBtn.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                loadSignInView()
            }
            .store(in: &cancellables)
        
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


