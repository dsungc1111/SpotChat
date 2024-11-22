//
//  EditVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/21/24.
//


import UIKit
import Combine
import PhotosUI

final class EditUserVC: BaseVC, PHPickerViewControllerDelegate {
    
    
    private let editUserView = EditUserView()
    private let editVM = EditVM()
    
    
    private var cancellables = Set<AnyCancellable>()
    
    private var selectedImageViews: UIImageView?
    
    
    override func loadView() {
        view = editUserView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        
        let input = editVM.input
        
        editUserView.photoPicker.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                openGallery()
            }
            .store(in: &cancellables)
        

        editUserView.nicknameTextField.textPublisher
            .map { $0 ?? "" }
            .map {  value in
                let query = value == "" ? UserDefaultsManager.userNickname : value
                return query
            }
            .subscribe(input.nicknameString)
            .store(in: &cancellables)
        
        editUserView.bioTextfield.textPublisher
            .map { $0 ?? "" }
            .map {  value in
                let query = value == "" ? "Not bio yet." : value
                return query
            }
            .subscribe(input.bioString)
            .store(in: &cancellables)
        
        
        editUserView.editButton.tapPublisher
            .subscribe(input.editBtnTapped)
            .store(in: &cancellables)
        
        let output = editVM.transform(input: input)
        
      
    }
    
    private func openGallery() {
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        dismiss(animated: true)
        
        selectedImageViews = editUserView.imageView
        
        for (index, result) in results.enumerated() {
            guard index < 1 else { break }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage,
                   let imageData = image.pngData() {
                    DispatchQueue.main.async {
                        self?.selectedImageViews?.image = image
                        self?.editVM.input.selectedImage.send(imageData)
                    }
                }
            }
        }
    }
}
