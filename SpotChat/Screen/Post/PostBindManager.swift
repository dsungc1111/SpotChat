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
    func bind(view: PostView, viewModel: PostVM, vc: PostVC, imagePicker: PostImagePickerManagerProtocol)
}

final class PostBindingManager: PostBindManagerProtocol {
  
    private var cancellables = Set<AnyCancellable>()
    
    func bind(view: PostView, viewModel: PostVM, vc: PostVC , imagePicker: PostImagePickerManagerProtocol) {
        
        let input = viewModel.input
        _ = viewModel.transform(input: input)
        
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
        
        view.photoButton.tapPublisher
            .sink {  _ in
                imagePicker.openGallery(in: vc)
            }
            .store(in: &cancellables)
        
       view.createPostButton.tapPublisher
            .sink { _ in
                viewModel.input.postBtnTap.send(())
            }
            .store(in: &cancellables)
        
//        imagePicker.finishImagePick = { [weak self] images in
//            guard let self else { return }
//            dataSourceProvider.updateDataSource(with: images)
//            let imageData = images.compactMap { $0.jpegData(compressionQuality: 0.3) }
//            postVM.input.postImageQuery.send(PostImageQuery(imageData: imageData))
//        }
    }
}
