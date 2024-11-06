//
//  PopupModifier.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/29/24.
//

import SwiftUI

// Custom ViewModifier to handle the popup
struct PopupModifier<Popup: View>: ViewModifier {
    @Binding var isPresented: Bool
    var content: () -> Popup

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                self.content()
                    .transition(.scale)
                    .animation(.easeInOut(duration: 0.3))
            }
        }
    }
}

extension View {
    func popup<Popup: View>(isPresented: Binding<Bool>, content: @escaping () -> Popup) -> some View {
        self.modifier(PopupModifier(isPresented: isPresented, content: content))
    }
}
