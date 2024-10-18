//
//  ImageRenderer.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 18/10/24.
//

import SwiftUI
import UIKit

final class ImageRenderer: UIViewRepresentable {
    let content: () -> UIView
    private var uiView: UIView? // Hold a reference to the created UIView
    
    init(content: @escaping () -> UIView) {
        self.content = content
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = content()
        uiView = view // Store the reference
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func render() -> UIImage? {
        guard let uiView = uiView else { return nil } // Safely unwrap the uiView reference
        
        let renderer = UIGraphicsImageRenderer(bounds: uiView.bounds)
        return renderer.image { _ in
            uiView.drawHierarchy(in: uiView.bounds, afterScreenUpdates: true)
        }
    }
}
