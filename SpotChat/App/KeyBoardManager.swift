//
//  KeyBoardManager.swift
//  SpotChat
//
//  Created by 최대성 on 12/8/24.
//

import UIKit

final class KeyboardManager: NSObject, UIGestureRecognizerDelegate {

    static let shared = KeyboardManager()

    private override init() {}

    private var keyboardWillShowHandler: ((CGFloat) -> Void)?
    private var keyboardWillHideHandler: (() -> Void)?
    private weak var observingView: UIView?
    private var excludedViews: [UIView] = []

    func configure(
        observingView: UIView?,
        excludedViews: [UIView] = [],
        keyboardWillShow: ((CGFloat) -> Void)? = nil,
        keyboardWillHide: (() -> Void)? = nil,
        dismissOnTap: Bool = false
    ) {
        self.observingView = observingView
        self.keyboardWillShowHandler = keyboardWillShow
        self.keyboardWillHideHandler = keyboardWillHide
        self.excludedViews = excludedViews

        addObservers()

        if dismissOnTap {
            addTapGesture(to: observingView)
        }
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardHeight = extractKeyboardHeight(from: notification) else { return }
        keyboardWillShowHandler?(keyboardHeight)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardWillHideHandler?()
    }

    private func extractKeyboardHeight(from notification: Notification) -> CGFloat? {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return nil }
        return frame.height
    }

    private func addTapGesture(to view: UIView?) {
        guard let view = view else { return }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self // Set delegate for custom behavior
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        observingView?.endEditing(true)
    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // If the touch is in an excluded view, ignore the gesture
        if let touchedView = touch.view, excludedViews.contains(touchedView) {
            return false
        }
        return true
    }
}
