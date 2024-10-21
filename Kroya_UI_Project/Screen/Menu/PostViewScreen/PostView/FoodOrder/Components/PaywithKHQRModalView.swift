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
                Spacer().frame(height: 15)
                
                // Display QR Code
                QRCodeView(text: "00020101021130450016abaakhppxxx@abaa01090045514050208ABA Bank40390006abaP2P0112B7A47E5B00EA02090045514055204000053031165802KH5914OUN BONALIHENG6010Phnom Penh6304AFE1", size: 200)
                
                Spacer().frame(height: 20)
                
                // Button to download QR code
                Button {
                    savePaymentCardAsImage()  // Save payment card as PNG
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
    func savePaymentCardAsImage() {
        withAnimation {
            downloadSuccess = true
        }
        
        let image = ImageRendererQR.renderView(view: VStack(alignment: .leading) {
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
                Spacer().frame(height: 15)
                
                // QR Code
                QRCodeView(text: "00020101021130450016abaakhppxxx@abaa01090045514050208ABA Bank40390006abaP2P0112B7A47E5B00EA02090045514055204000053031165802KH5914OUN BONALIHENG6010Phnom Penh6304AFE1", size: 200)
                
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

#Preview {
    PaywithKHQRModalView()
}
