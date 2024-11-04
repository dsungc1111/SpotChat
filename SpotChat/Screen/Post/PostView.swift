//
//  PostView.swift
//  SpotChat
//
//  Created by 최대성 on 11/4/24.
//

import UIKit
import SnapKit


final class PostView: BaseView {
    
    let photoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera.circle")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
//        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let titleTextField = {
        let view = UITextField()
        view.placeholder = "제목을 입력하세요 :)"
        view.borderStyle = .roundedRect
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        view.leftViewMode = .always
        return view
    }()
    
    private let contentTextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.font = .systemFont(ofSize: 14)
        view.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.textColor = .lightGray
        view.text = "내용을 입력하세요 :)"
        return view
    }()
    
    private let priceLabel = {
        let view = UILabel()
        view.text = "가격"
        return view
    }()
    
    private let priceTextField = {
        let view = UITextField()
        view.placeholder = "가격 필드"
        view.keyboardType = .numberPad
        return view
    }()
    
    private lazy var contentView = {
        let view = UIView()
        view.addSubview(photoButton)
        view.addSubview(titleTextField)
        view.addSubview(contentTextView)
        view.addSubview(priceLabel)
        view.addSubview(priceTextField)
        return view
    }()
    
    private let scrollTapGesture = UITapGestureRecognizer()
    
    private lazy var scrollView = {
        let view = UIScrollView()
        view.addSubview(contentView)
        return view
    }()
    
    private let createPostButton = {
        let btn = UIButton()
        btn.setTitle("  게시", for: .normal)
        btn.backgroundColor = .lightGray
        btn.setImage(UIImage(systemName: "square.and.arrow.up.on.square"), for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 10
        btn.isEnabled = false
        return btn
    }()
    
    override func configureHierarchy() {
        addSubview(scrollView)
        addSubview(createPostButton)
    }
    
    override func configureLayout() {
        
        photoButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(80)
        }
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(photoButton.snp.bottom).offset(20)
            $0.leading.equalTo(photoButton)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(44)
        }
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(titleTextField)
            $0.height.equalTo(200)
        }
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(20)
            $0.leading.equalTo(contentTextView)
        }
        priceTextField.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(contentTextView)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().offset(-20)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        createPostButton.snp.makeConstraints {
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-8)
            $0.horizontalEdges.equalTo(priceTextField)
            $0.height.equalTo(44)
        }
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(createPostButton.snp.top)
        }
    }
}
