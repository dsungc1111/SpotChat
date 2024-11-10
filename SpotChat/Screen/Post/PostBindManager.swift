//
//  BindManager.swift
//  SpotChat
//
//  Created by 최대성 on 11/10/24.
//

import UIKit
import Combine
import CombineCocoa

protocol PostBindManagerProtocol: AnyObject {
    func bind(view: PostView, viewModel: PostVM)
}

final class PostBindingManager: PostBindManagerProtocol {
  
    private var cancellables = Set<AnyCancellable>()
    
    func bind(view: PostView, viewModel: PostVM) {
        
        let input = viewModel.input
        
        view.titleTextField.textPublisher
            .compactMap { $0 }
            .subscribe(input.titleText)
            .store(in: &cancellables)
        
        view.contentTextView.textPublisher
            .compactMap { $0 }
            .subscribe(input.contentText)
            .store(in: &cancellables)
        

        view.DMSegmentedControl.selectedSegmentIndexPublisher
            .compactMap{ $0 == 0 ? "true" : "false" }
            .subscribe(input.messagePossible)
            .store(in: &cancellables)
        
        view.JoinSegmentedControl
            .selectedSegmentIndexPublisher
            .compactMap{ $0 == 0 ? "true" : "false" }
            .subscribe(input.meetingPossible)
            .store(in: &cancellables)
        
        view.hashTagTextField.textPublisher
            .compactMap { $0 }
            .subscribe(input.hashTagText)
            .store(in: &cancellables)
        
//        view.photoButton.tapPublisher
//            .sink { [weak self] _ in
//                guard let self else { return }
//                selectedImages = []
//                openGallery()
//            }
//            .store(in: &cancellables)
        
        view.createPostButton.tapPublisher
            .map { _ in }
            .subscribe(input.postBtnTap)
            .store(in: &cancellables)
        
        
        
    }
}
