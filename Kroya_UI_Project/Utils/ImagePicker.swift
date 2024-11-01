//
//  ImagePicker.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 17/10/24.
//

import SwiftUI
import PhotosUI

//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImages: [UIImage]
//
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var config = PHPickerConfiguration()
//        config.filter = .images
//        config.selectionLimit = 0 // Allow multiple selections
//
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        var parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            picker.dismiss(animated: true)
//
//            for result in results {
//                // Try to get the file name using PHAsset
//                if let assetId = result.assetIdentifier {
//                    let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
//                    if let asset = assetResults.firstObject {
//                        let resource = PHAssetResource.assetResources(for: asset).first
//                        let fileName = resource?.originalFilename ?? "Unknown"
//                        
//                        print("Selected image name: \(fileName)")
//                    }
//                }
//
//                // Load and append the image to the selectedImages array
//                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
//                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
//                        if let uiImage = image as? UIImage {
//                            DispatchQueue.main.async {
//                                self.parent.selectedImages.append(uiImage)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//}



struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 0

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let error = error {
                            print("Error loading image: \(error.localizedDescription)")
                            return
                        }
                        if let uiImage = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(uiImage)
                                print("Image successfully added.")
                            }
                        } else {
                            print("Failed to cast loaded object to UIImage.")
                        }
                    }
                } else {
                    print("Item provider cannot load UIImage.")
                }
            }
        }
    }
}
