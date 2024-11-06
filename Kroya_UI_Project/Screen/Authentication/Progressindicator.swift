//
//  Progressindicator.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 12/10/24.
//

import SwiftUI

struct ProgressIndicator: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                .scaleEffect(2)
        }
    }
}
