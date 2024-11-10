//
//  ImagePickerManager.swift
//  SpotChat
//
//  Created by 최대성 on 11/10/24.
//

import UIKit
import PhotosUI

protocol PostImagePickerManagerProtocol: AnyObject {
    
    // 픽된 이미지 PostVC로 전달해주는 클로저
    var finishImagePick: (([UIImage]) -> Void)? { get set }
    func openGallery(in viewController: UIViewController)
}

final class PostImagePickerManager: PHPickerViewControllerDelegate, PostImagePickerManagerProtocol {
    var finishImagePick: (([UIImage]) -> Void)?
    
    var selectedImages: (([UIImage]) -> Void)?
    
    func openGallery(in viewController: UIViewController) {
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewController.present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        var selectedImages: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        
        results.forEach { result in
            dispatchGroup.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                        selectedImages.append(image)
//                        self?.dataSourceProvider.updateDataSource(with: self?.selectedImages ?? [])
                }
                dispatchGroup.leave()
            }
        }
        // 5장 로드된 후 한번에 전달
        dispatchGroup.notify(queue: .main) {
            self.finishImagePick?(selectedImages)
        }
        
    }
    
    
    
}
