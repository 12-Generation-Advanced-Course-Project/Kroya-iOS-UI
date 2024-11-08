//
//  FoodRecipeService.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/11/24.
//


import SwiftUI
import Alamofire

class FoodRecipeService {
    
    static let shared = FoodRecipeService()
    
    // MARK: Get FoodRecipe
    func getFoodRecipe(completion: @escaping (Result<foodrecipeResponse, Error>) -> Void) {
        let url = Constants.FoodRecipeUrl + "list"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")"
        ]
        AF.request(url, method: .get, headers: headers).validate()
            .responseDecodable(of: foodrecipeResponse.self) { response in
                debugPrint(response)
                switch response.result{
                case .success(let apiResponse):
                    if let statusCode = Int(apiResponse.statusCode), statusCode == 200 {
                        print("getFoodRecipe successfully.")
                        print("recipe response:\(String(describing: apiResponse.payload))")
                        completion(.success(apiResponse))
                    } else {
                        print("Failed to retrieve user profile.")
                        let error = NSError(domain: "", code: 400,
                                            userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion(.failure(error))
                }
            }
        
    }
}
