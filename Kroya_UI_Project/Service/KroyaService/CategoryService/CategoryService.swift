//
//  CategoryService.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/11/24.
//

import SwiftUI
import Alamofire

class CategoryService{
    static let shared = CategoryService()
    
    //MARK: Get All Category
    func getAllCategory(completion: @escaping (Result<CategoryResponses, Error>) -> Void){
        let url = Constants.CategoryUrl + "all"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")"
        ]
        
        AF.request(url, method: .get , headers: headers).validate()
            .responseDecodable(of: CategoryResponses.self){ response in
                debugPrint(response)
                switch response.result{
                case .success(let apiResponse):
                    if let statusCode = Int(apiResponse.statusCode), statusCode == 200{
                        print("List of categories retrieved successfully.")
                        print("This is the user profile:\(String(describing: apiResponse.payload))")
                        completion(.success(apiResponse))
                    }else{
                        print("Failed to retrieve categories.")
                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion(.failure(error))
                }
            }
    }
}
