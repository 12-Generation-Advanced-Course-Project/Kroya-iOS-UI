//
//  UserFoodService.swift
//  Kroya_UI_Project
//
//  Created by kosign on 7/11/24.
//

import SwiftUI
import Alamofire


class UserFoodService {
    
    static let shared = UserFoodService()
    
    //MARK: Get all User Food
    func fetchAllUserFood(completion: @escaping (Result<userFoodResponse, Error>) -> Void){
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        let url = Constants.UserFoodUrl + "foods"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")"
        ]
        
        AF.request(url, method: .get , headers:  headers).validate()
            .responseDecodable(of: userFoodResponse.self){ response in
                switch response.result {
                case .success(let apiResponse):
                    if apiResponse.statusCode == "200" {
                        print("Get all food retrieved successfully.")
                        completion(.success(apiResponse))
                    } else {
                        print("Failed to retrieved Food listings")
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
