//
//  PostVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/4/24.
//

import UIKit
import PhotosUI
import Combine
import CombineCocoa

final class PostVC: BaseVC {
   
    private let postView = PostView()
    private let postVM = PostVM()
    private var cancellables = Set<AnyCancellable>()
    private var selectedImages: [UIImage] = []
    private var dataSourceProvider: DataSourceProvider!
        
    override func loadView() {
        view = postView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSourceProvider = DataSourceProvider(collectionView: postView.collectionView)
    }
    
    override func bind() {
        
//        let postQuery = PostImageQuery(imageData: <#T##Data?#>)
       
        let input = PostVM.Input(
            categoryText: PassthroughSubject<String, Never>(),
            titleText: PassthroughSubject<String, Never>(),
            hashTagText: PassthroughSubject<String, Never>(),
            contentText: PassthroughSubject<String, Never>(),
            messagePossible: PassthroughSubject<String, Never>(),
            meetingPossible: PassthroughSubject<String, Never>(),
            postBtnTap: PassthroughSubject<Void, Never>()
        )
        
        postView.DMSegmentedControl.selectedSegmentIndexPublisher
            .compactMap{ $0 == 0 ? "true" : "false" }
            .subscribe(input.meetingPossible)
            .store(in: &cancellables)
        
        
        
        let output = postVM.transform(input: input)
        
        /*
         클로저
         후행클로저
         */
        
        postView.photoButton.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                selectedImages = []
                openGallery()
            }
            .store(in: &cancellables)
        
//        postView.createPostButton.tapPublisher
//            .map { _ in }
//            .subscribe(input.postBtnTap)
//            .store(in: &cancellables)
        
    }
    
}

extension PostVC: PHPickerViewControllerDelegate {
    
    private func openGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.selectedImages.append(image)
                        self?.dataSourceProvider.updateDataSource(with: self?.selectedImages ?? [])
                    }
                }
            }
        }
    }
}
