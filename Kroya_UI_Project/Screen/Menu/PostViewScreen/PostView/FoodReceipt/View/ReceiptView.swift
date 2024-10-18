
//
//  ReceiptView.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 15/10/24.
//

import UIKit
import Photos
import SwiftUI
struct ReceiptView: View {
    
    @State private var presentPopup = false
    @ObservedObject var viewModel = ReceiptViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Success()
                        .padding(.top, 40)
                    
                    // Pass parameters in the correct order
                    ReceiptCard(viewModel: viewModel, presentPopup: $presentPopup)
                }
                .padding(.bottom, 50)
                .navigationTitle("Receipt")
                .navigationBarTitleDisplayMode(.inline)
                
                if presentPopup {
                
                    Popup(isPresented: $presentPopup) {
                        ReceiptCard(viewModel: viewModel, presentPopup: $presentPopup)
                    }
                }
                
             
            }
        }
    }
    
    // Save the receipt as PNG
    private func saveReceiptAsPNG() {
        let renderer = ImageRenderer {
            // Capture the ReceiptCard here
            let receiptCard = ReceiptCard(viewModel: viewModel, presentPopup: $presentPopup)
            return UIHostingController(rootView: receiptCard).view
        }

        if let image = renderer.render() {
            if let pngData = image.pngData() {
                // Request access to save image to Photos
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: UIImage(data: pngData)!)
                }) { success, error in
                    if success {
                        print("Receipt saved as PNG!")
                    } else if let error = error {
                        print("Error saving receipt: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
}


#Preview {
    ReceiptView()
}
