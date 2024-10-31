//
//  KeyboardObserver.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 30/10/24.
//

import SwiftUI
import Combine

class KeyboardObserver: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0

    private var cancellables: Set<AnyCancellable> = []

    init() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

        willShow
            .merge(with: willHide)
            .sink { [weak self] notification in
                if notification.name == UIResponder.keyboardWillShowNotification,
                   let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    self?.keyboardHeight = keyboardFrame.height
                } else {
                    self?.keyboardHeight = 0
                }
            }
            .store(in: &cancellables)
    }
}
