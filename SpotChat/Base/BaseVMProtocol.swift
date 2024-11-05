//
//  BaseVMProtocol.swift
//  SpotChat
//
//  Created by 최대성 on 10/31/24.
//

import Foundation
import Combine


protocol BaseVMProtocol: AnyObject {
    
    
    associatedtype Input
    associatedtype Output
    
    var cancellables: Set<AnyCancellable> { get }
    
    func transform(input: Input) -> Output
}
