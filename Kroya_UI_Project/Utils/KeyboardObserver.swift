//
//  KeyboardObserver.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 30/10/24.
//

import SwiftUI
import Combine

// MARK: - KeyboardResponder Class
class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0

    private var cancellableSet: Set<AnyCancellable> = []

    // Define a maximum height for the keyboard to prevent excessive padding
    private let maxKeyboardHeight: CGFloat = 300

    init() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    // Cap the keyboard height to the maximum value
                    return min(frame.height, self.maxKeyboardHeight)
                }
                return 0
            }

        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in
                return 0
            }

        Publishers.Merge(willShow, willHide)
            .receive(on: RunLoop.main)
            .assign(to: \.currentHeight, on: self)
            .store(in: &cancellableSet)
    }

    deinit {
        cancellableSet.forEach { $0.cancel() }
    }
}

// MARK: - View Extension to Dismiss Keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
