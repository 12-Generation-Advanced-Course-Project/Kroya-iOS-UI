//
//  ImageUploadViewModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 17/10/24.
//

import SwiftUI
import Alamofire

class ImageUploadViewModel: ObservableObject {
    @Published var data: ImageResponse?
    // Upload - Image_Article
    func uploadFile(image: Data, completion: @escaping (String) -> Void) {
        let baseUrl = "http://110.74.194.123:8080/api/v1/images/upload"
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image, withName: "file", fileName: "image.png", mimeType: "image/png")
        }, to: baseUrl, headers: headers)
        .responseDecodable(of: ImageResponse.self) { response in
            switch response.result {
            case .success(let res):
                self.data = res
                if let imageName = res.imageName {
                    completion(imageName)
                    print("This is the image name: \(imageName)")
                } else {
                    print("Image name is nil")
                }
            case .failure(let error):
                print("Image upload failed: \(error)")
            }
        }
    }
}
