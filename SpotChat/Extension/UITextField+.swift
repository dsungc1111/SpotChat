//
//  UITextField+.swift
//  SpotChat
//
//  Created by 최대성 on 11/9/24.
//

import UIKit
import Combine
//
//extension UITextField {
//    var publisher: AnyPublisher<String, Never> {
//        // UItextfeild가 수정될 때마다 새로운 이벤트 방출하도록
//        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
//        // NotificationCenter로 들어온 notification의 optional타입 object 프로퍼티를 UItextfeild로 타입 캐스팅(object의 타입은 AnyObject타입이기 때문)
//            .compactMap { $0.object as? UITextField }
//            .map { $0.text ?? "" }
//        //디버깅 용 print
////            .print()
//        //publisher의 구체적인 타입을 Anypublisher로 숨김
//        // 타입을 숨겨 불필요한 타입 의존성을 피함
//        // 외부에선 내부의변화에 대한 신경으 ㄹ쓸 필요가 없어짐
//            .eraseToAnyPublisher()
//    }
//}
//
//
//extension UITextView {
//    var publisher: AnyPublisher<String, Never> {
//        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: self)
//            .compactMap { $0.object as? UITextView }
//            .map { $0.text ?? "" }
//            .eraseToAnyPublisher()
//    }
//}
