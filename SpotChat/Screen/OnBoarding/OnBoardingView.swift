//
//  OnBoardingView.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit
import SnapKit

final class OnBoardingView: BaseView {
    
    private let imageView =  {
        let view = UIImageView()
        view.image = UIImage(named: "SpotChat")
        return view
    }()
    let loginBtn = {
        let btn = UIButton()
        btn.setTitle("로그인하기", for: .normal)
        btn.setTitleColor(UIColor(hexCode: "#F4EC78", alpha: 1), for: .normal)
        return btn
    }()
    
    override func configureHierarchy() {
        addSubview(imageView)
        addSubview(loginBtn)
    }
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide).offset(-40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(195)
        }
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
    }
    
    
}
