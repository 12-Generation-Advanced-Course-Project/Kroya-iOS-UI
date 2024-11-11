import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    // Callback to return selected images and their filenames
    var onImagesPicked: (_ selectedImages: [UIImage], _ filenames: [String]) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 0 // Allow multiple selections

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

            var selectedImages: [UIImage] = []
            var filenames: [String] = []

            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let error = error {
                            print("Error loading image: \(error.localizedDescription)")
                            return
                        }

                        if let uiImage = image as? UIImage {
                            // Generate a unique filename and save each image
                            if let filename = self.saveImageToFile(uiImage) {
                                DispatchQueue.main.async {
                                    selectedImages.append(uiImage)
                                    filenames.append(filename)
                                    // Once all images are processed, pass back to the parent
                                    if filenames.count == results.count {
                                        self.parent.onImagesPicked(selectedImages, filenames)
                                    }
                                }
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

        // Function to save UIImage to file and return the filename
        private func saveImageToFile(_ image: UIImage) -> String? {
            let uuid = UUID().uuidString
            let fileExtension = "jpg"  // Save as JPEG
            let filename = "\(uuid).\(fileExtension)"

            // Compress image and save to file
            if let data = image.jpegData(compressionQuality: 0.8) {
                let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
                do {
                    try data.write(to: fileURL)
                    print("Image saved as \(filename)")
                    return filename
                } catch {
                    print("Failed to save image to file: \(error.localizedDescription)")
                }
            }
            return nil
        }

        // Helper function to get the Documents directory path
        private func getDocumentsDirectory() -> URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
    }
}
