//
//  SettingVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/1/24.
//

import Foundation
import Combine


final class SettingVC: BaseVC {
    
    private let settingView = SettingView()
    
    private let settingVM = SettingVM()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = settingView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("세팅뷰")
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func bind() {
        
        let trigger = PassthroughSubject<String, Never>()
        
        
        let input = SettingVM.Input(trigger: trigger)
        
        let output = settingVM.transform(input: input)
        
        
        trigger.send(UserDefaultManager.userId)
        
        
        output.myInfoList
            .sink { [weak self] myInfo in
                guard let self else { return }
                print(Thread.isMainThread)
                DispatchQueue.main.async {
                    self.settingView.configureView(info: myInfo)
                }
                
            }
            .store(in: &cancellables)
        
    }
    
}
