//
//  LoaingViewModifier.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 11/11/24.
//

import SwiftUI
// MARK: - Loading Overlay
struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                .scaleEffect(1.5)
                .padding()
        }
    }
}

