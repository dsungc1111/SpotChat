//
//  UIButton+.swift
//  SpotChat
//
//  Created by 최대성 on 11/9/24.
//

import UIKit

private var associatedKey: UInt8 = 0

// 번튼에 연관값을 만들어 userid 전달
extension UIButton {
    var associatedValue: String? {
        get {
            return objc_getAssociatedObject(self, &associatedKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &associatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
