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
    
    private var cancellables = Set<AnyCancellable>()
    
    private let postView: PostView
    private let postVM: PostVM
    private let bindManager: PostBindManagerProtocol
    private let imagePickerManager: PostImagePickerManagerProtocol
    private var dataSourceProvider: any PostDataSourceProviderProtocol
    
    
    init(
        postView: PostView,
        postVM: PostVM,
        bindManager: PostBindManagerProtocol,
        imagePickerManager: PostImagePickerManagerProtocol,
        dataSourceProvider: any PostDataSourceProviderProtocol
    ) {
        
        self.bindManager = bindManager
        self.postVM = postVM
        self.postView = postView
        self.imagePickerManager = imagePickerManager
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
        KeyboardManager.shared.configure(observingView: view,
                                         excludedViews: [
                                            postView.DMSegmentedControl,
                                            postView.JoinSegmentedControl
                                         ]
                                         ,
                                         dismissOnTap: true)
    }
    
    override func bind() {
        
        bindManager.bind(view: postView, 
                         viewModel: postVM,
                         vc: self,
                         imagePicker: imagePickerManager, 
                         dataSourceManager: dataSourceProvider)
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        KeyboardManager.shared.removeObservers()
    }
    
    
}
