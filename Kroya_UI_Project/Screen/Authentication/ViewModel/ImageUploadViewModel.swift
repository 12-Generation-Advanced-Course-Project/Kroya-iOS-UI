//
//  ImageUploadViewModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 17/10/24.
//

import Alamofire
import Combine
import Foundation

class ImageUploadViewModel: ObservableObject {
    @Published var data: ImageResponse?

    // Upload image function
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
                self.data = res
                if let imageUrl = res.payload.first {
                    completion(imageUrl)
                    print("This is the image URL: \(imageUrl)")
                } else {
                    print("Image URL is nil")
                    completion("")
                }
            case .failure(let error):
                print("Image upload failed: \(error)")
                completion("")
            }
        }
    }

}
