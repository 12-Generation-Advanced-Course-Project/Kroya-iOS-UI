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
                if let data = response.data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                        if let prettyString = String(data: prettyData, encoding: .utf8) {
                            print("Get all user food JSON Response:\n\(prettyString)")
                        }
                    } catch {
                        print("Failed to convert response get all user food  to JSON: \(error)")
                    }
                } else {
                    print("No response all food data available")
                }
                debugPrint(response)
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
