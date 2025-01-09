//
//  PaymentVC.swift
//  SpotChat
//
//  Created by 최대성 on 12/19/24.
//

import Foundation
import iamport_ios
import WebKit



final class PaymentVC: BaseVC {
    
    
    let webView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    
    
    override func viewDidLoad() {
        print("hi~")
    }
    
}
