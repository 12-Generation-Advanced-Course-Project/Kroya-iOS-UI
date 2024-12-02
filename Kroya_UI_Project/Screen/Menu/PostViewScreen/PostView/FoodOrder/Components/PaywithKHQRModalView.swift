//
//  PaywithKHQRModalView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 17/10/24.
//

import SwiftUI
import UIKit
import Photos

// ImageRendererQR Class to capture the view as UIImage
final class ImageRendererQR {
    static func renderView<T: View>(view: T) -> UIImage? {
        let controller = UIHostingController(rootView: view)
        let view = controller.view
        
        // Set the size of the view to match the screen width (or custom size)
        let targetSize = CGSize(width: UIScreen.main.bounds.width, height: 400) // Height can be customized
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .white
        
        // Render the view into an image
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
    }
}

struct PaywithKHQRModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var downloadSuccess = false
    var SellerName:String
    var totalAmount:Int
    var khqrData:String
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 40)
            Image("webill365_logo_full 1")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 15)
            
            VStack {
                Text("Scan QR Code")
                    .font(.customfont(.semibold, fontSize: 24))
                Spacer().frame(height: 10)
                Text("Download this QR Code for payment")
                    .font(.customfont(.medium, fontSize: 14))
                    .foregroundStyle(.black.opacity(0.8))
                Spacer().frame(height: 20)
                VStack(alignment: .leading,spacing: 10){
                    Text(SellerName)
                        .font(.customfont(.bold, fontSize: 15))
                        .foregroundStyle(.black.opacity(0.8))
                    Text("៛\(totalAmount)")
                        .font(.customfont(.bold, fontSize: 15))
                        .foregroundStyle(.black.opacity(0.8))
                }
                .padding(.horizontal,80)
                .frame(maxWidth: .infinity,alignment: .leading)
                // Display QR Code
                QRCodeView(text: khqrData, size: 200)
                
                Spacer().frame(height: 20)
                
                // Button to download QR code
                Button {
                    savePaymentCardAsImage(khrData: khqrData)  // Save payment card as PNG
                } label: {
                    HStack {
                        Image(systemName: "arrowshape.down.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .accentColor(.white)
                        Text(downloadSuccess ? "Download Success" : "Download QR Code")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .screenWidth, minHeight: 50, alignment: .center)
                .background(downloadSuccess ? .green : PrimaryColor.normal )
                .cornerRadius(10)
                .padding()
                .disabled(downloadSuccess)
                
                Text("Not Now")
                    .font(.customfont(.semibold, fontSize: 16))
                    .foregroundStyle(PrimaryColor.normal)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, minHeight: .screenHeight * 0.05, alignment: .center)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(radius: 20)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // Function to save the displayed payment card as PNG
    func savePaymentCardAsImage(khrData:String) {
        withAnimation {
            downloadSuccess = true
        }
        
        let image = ImageRendererQR.renderView(view:
    VStack(alignment: .leading) {
            VStack {
                Image("webill365_logo_full 1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 15)
                Text("Scan QR Code")
                    .font(.customfont(.semibold, fontSize: 24))
                Spacer().frame(height: 10)
                Text("Download this QR Code for payment")
                    .font(.customfont(.medium, fontSize: 14))
                    .foregroundStyle(.black.opacity(0.8))
                Spacer().frame(height: 15)
                
                // QR Code
                QRCodeView(text: khrData, size: 200)
              
                Spacer()
            }
        })

        guard let pngImage = image, let pngData = pngImage.pngData() else {
            return
        }

        // Save the image as PNG to the photo library
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: UIImage(data: pngData)!)
        }) { success, error in
            if success {
                print("QR code saved successfully!")
            } else if let error = error {
                print("Error saving QR code: \(error.localizedDescription)")
            }
        }
    }
}
