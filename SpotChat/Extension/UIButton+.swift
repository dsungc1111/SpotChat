//
//  UIButton+.swift
//  SpotChat
//
//  Created by 최대성 on 11/9/24.
//

import UIKit
import Combine
//
//extension UIControl {
//    func controlEventPublisher(for event: UIControl.Event) -> AnyPublisher<Void, Never> {
//        Publishers.ControlEvent(control: self, event: event)
//            .map { _ in }
//            .eraseToAnyPublisher()
//    }
//}
//
//extension UIButton {
//    var tapPublisher: AnyPublisher<Void, Never> {
//        controlEventPublisher(for: .touchUpInside)
//    }
//}
//extension UISegmentedControl {
//    /// A publisher emitting selected segment index changes for this segmented control.
//    var selectedSegmentIndexPublisher: AnyPublisher<Int, Never> {
//        Publishers.ControlProperty(control: self, events: .valueChanged, keyPath: \.selectedSegmentIndex)
//                  .eraseToAnyPublisher()
//    }
//}
//
