//
//  KeyBoardManager.swift
//  SpotChat
//
//  Created by 최대성 on 12/8/24.
//

import UIKit

final class KeyboardManager {
    
    static let shared = KeyboardManager()
    
    private init() {}
    
    private var keyboardWillShowHandler: ((CGFloat) -> Void)?
    private var keyboardWillHideHandler: (() -> Void)?
    private weak var observingView: UIView?
    
    
    // 키보드 이벤트 등록
    func configure(
        observingView: UIView?,
        keyboardWillShow: ((CGFloat) -> Void)? = nil,
        keyboardWillHide: (() -> Void)? = nil,
        dismissOnTap: Bool = false
    ) {
        self.observingView = observingView
        self.keyboardWillShowHandler = keyboardWillShow
        self.keyboardWillHideHandler = keyboardWillHide
        
        addObservers()
        
        if dismissOnTap {
            addTapGesture(to: observingView)
        }
    }
    
    // 옵저버 추가
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // 키보드 이벤트 해제
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드 나타날 때 처리
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardHeight = extractKeyboardHeight(from: notification) else { return }
        keyboardWillShowHandler?(keyboardHeight)
    }
    
    // 키보드 숨길 때 처리
    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardWillHideHandler?()
    }
    
    // 키보드 높이 추출
    private func extractKeyboardHeight(from notification: Notification) -> CGFloat? {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return nil }
        return frame.height
    }
    
    // 탭 제스처 (키보드 숨김 처리)
    private func addTapGesture(to view: UIView?) {
        guard let view = view else { return }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // 키보드 숨김 처리
    @objc private func hideKeyboard() {
        observingView?.endEditing(true)
    }
    
}
