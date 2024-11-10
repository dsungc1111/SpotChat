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
    
    private var cancellables = Set<AnyCancellable>()
    
    private let postVM: any BaseVMProtocol
    private let bindManager: PostBindManagerProtocol
    private let imagePickerManager: PostImagePickerManager
    private var dataSourceProvider: any PostDataSourceProviderProtocol
    
    
    init(
        bindManager: PostBindManagerProtocol,
        postVM: any BaseVMProtocol,
        imagePickerManager: PostImagePickerManagerProtocol,
        dataSourceProvider: any PostDataSourceProviderProtocol
    ) {
        
        self.bindManager = bindManager
        self.postVM = postVM
        self.imagePickerManager = imagePickerManager as! PostImagePickerManager
        self.dataSourceProvider = dataSourceProvider
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
 
    override func loadView() {
        view = postView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        bindManager.bind(view: postView, viewModel: postVM as! PostVM)
        
        imagePickerManager.selectedImages = { [weak self] images in
            guard let self else { return }
            dataSourceProvider.updateDataSource(with: images)
        }
        
        postView.photoButton.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                imagePickerManager.openGallery(in: self)
            }
            .store(in: &cancellables)
    }
    
}
