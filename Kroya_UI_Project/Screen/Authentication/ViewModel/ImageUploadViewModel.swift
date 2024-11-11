//
//  ImageUploadViewModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 17/10/24.
//

import Alamofire
import Foundation

import UIKit

class ImageUploadViewModel: ObservableObject {
    @Published var data: ImageResponse?
    
    func uploadFile(image: Data, completion: @escaping (String) -> Void) {
        let baseUrl = Constants.fileupload + "file"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")",
            "Content-Type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image, withName: "files", fileName: "image.png", mimeType: "image/png")
        }, to: baseUrl, headers: headers)
        .responseDecodable(of: ImageResponse.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let res):
                if let imageUrl = res.payload.first {
                    completion(imageUrl)
                } else {
                    completion("")
                }
            case .failure:
                completion("")
            }
        }
    }
    
    func uploadImages(_ images: [UIImage], completion: @escaping (Result<[String], Error>) -> Void) {
        var uploadedImageNames: [String] = []
        let dispatchGroup = DispatchGroup()
        
        for image in images {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                dispatchGroup.enter()
                
                uploadFile(image: imageData) { imageUrl in
                    if !imageUrl.isEmpty {
                        uploadedImageNames.append(imageUrl)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if uploadedImageNames.count == images.count {
                completion(.success(uploadedImageNames))
            } else {
                completion(.failure(NSError(domain: "Upload failed for some images", code: 0, userInfo: nil)))
            }
        }
    }
}
