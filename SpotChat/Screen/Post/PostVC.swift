//
//  PostVC.swift
//  SpotChat
//
//  Created by 최대성 on 11/4/24.
//

import UIKit
import PhotosUI


final class PostVC: BaseVC {
   
    private let postView = PostView()
    
    private let postVM = PostVM()

    
    
    override func loadView() {
        view = postView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
//        let input = PostVM.Input
        
    }
   
}



extension PostVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        results.first?.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] object, error in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self?.postView.photoButton.setImage(image, for: .normal)
                }
            }
        })
    }
}
