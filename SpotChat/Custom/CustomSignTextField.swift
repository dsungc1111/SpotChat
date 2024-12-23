//
//  CustomSignTextField.swift
//  SpotChat
//
//  Created by 최대성 on 10/29/24.
//

import UIKit


final class CustomSignTextField: UITextField {
    
    init(placeholderText: String) {
        super.init(frame: .zero)
        layer.cornerRadius = 10
        backgroundColor = .white
        textColor = .black
        leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        leftViewMode = .always
        attributedPlaceholder = NSAttributedString(string: placeholderText, attributes:  [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
