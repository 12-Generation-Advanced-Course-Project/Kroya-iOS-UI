//
//  SkeletonView.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 8/11/24.
//

import SwiftUI
import Shimmer
struct SkeletonView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 20)
            .redacted(reason: .placeholder)
    }
}
