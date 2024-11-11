//
//  LoaingViewModifier.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 11/11/24.
//

import SwiftUI

// MARK: - Loading View Modifier
struct LoadingViewModifier: ViewModifier {
    @Binding var isLoading: Bool
    var message: String = "Loading..."

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading) // Disable interactions when loading
                .blur(radius: isLoading ? 2 : 0) // Optional: add blur during loading
            
            if isLoading {
                LoadingView(message: message)
            }
        }
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var message: String

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.5)
                Text(message)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(20)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.8)))
            .shadow(radius: 10)
        }
    }
}
