//
//  QRCodeGenerate.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 17/10/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    let text: String
    let size: CGFloat

    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        if let qrImage = generateQRCode(from: text) {
            Image(uiImage: qrImage)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        } else {
            Image(systemName: "xmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        }
    }

    private func generateQRCode(from string: String) -> UIImage? {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return nil
    }
}
