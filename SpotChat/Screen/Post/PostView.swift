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
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "camera.circle")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
        return btn
    }()
    
    let DMSegmentedControl = {
        let segment = UISegmentedControl()
        
        segment.insertSegment(withTitle: "DM ON", at: 0, animated: true)
        segment.insertSegment(withTitle: "DM OFF", at: 1, animated: true)
        segment.selectedSegmentIndex = 0
        
        return segment
    }()
    
    let JoinSegmentedControl = {
        let segment = UISegmentedControl()
        
        segment.insertSegment(withTitle: "JOIN", at: 0, animated: true)
        segment.insertSegment(withTitle: "POST", at: 1, animated: true)
        segment.selectedSegmentIndex = 0
        
        return segment
    }()
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 80, height: 80)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력하세요 :)"
        textField.borderStyle = .roundedRect
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        return textField
    }()
    
    let contentTextView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.font = .systemFont(ofSize: 14)
        view.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.textColor = .lightGray
        view.text = "내용을 입력하세요 :)"
        return view
    }()
    
    private let hashTagLabel: UILabel = {
        let label = UILabel()
        label.text = "해시태그"
        label.textColor = .white
        return label
    }()
    
    let hashTagTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "해시태그 입력"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .white
        return textField
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.addSubview(photoButton)
        view.addSubview(titleTextField)
        view.addSubview(DMSegmentedControl)
        view.addSubview(JoinSegmentedControl)
        view.addSubview(collectionView)
        view.addSubview(contentTextView)
        view.addSubview(hashTagLabel)
        view.addSubview(hashTagTextField)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.addSubview(contentView)
        return view
    }()
    
    let createPostButton: UIButton = {
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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
    }
    
    override func configureLayout() {
        
        photoButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(80)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalTo(photoButton.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }
        
        DMSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(photoButton.snp.bottom).offset(20)
            make.leading.equalTo(photoButton)
            make.width.equalTo(120)
            make.height.equalTo(44)
        }
        JoinSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(photoButton.snp.bottom).offset(20)
            make.leading.equalTo(DMSegmentedControl.snp.trailing).offset(20)
            make.width.equalTo(120)
            make.height.equalTo(44)
        }
                
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(DMSegmentedControl.snp.bottom).offset(20)
            make.leading.equalTo(photoButton)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(titleTextField)
            make.height.equalTo(200)
        }
        
        hashTagLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
            make.leading.equalTo(contentTextView)
        }
        
        hashTagTextField.snp.makeConstraints { make in
            make.top.equalTo(hashTagLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentTextView)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        createPostButton.snp.makeConstraints { make in
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-8)
            make.horizontalEdges.equalTo(hashTagTextField)
            make.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(createPostButton.snp.top)
        }
    }
}
