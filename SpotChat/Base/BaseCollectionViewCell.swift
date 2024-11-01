//
//  BaseCollectionViewCell.swift
//  SpotChat
//
//  Created by 최대성 on 11/1/24.
//

import UIKit

protocol Identifier {
    static var identifier: String { get }
}

extension UICollectionViewCell: Identifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Identifier {
    static var identifier: String {
        return String(describing: self)
    }
}

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configureHierarchy() {}
    func configureLayout() {}
}
