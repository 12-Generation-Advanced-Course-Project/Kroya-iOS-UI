//
//  GuestCategoryService.swift
//  Kroya_UI_Project
//
//  Created by kosign on 21/11/24.
//

import Foundation
import Alamofire

class GuestCategoryService {
    
    static let shared = GuestCategoryService()
    
    //MARK: Get all Guest Categories
    func getAllGuestCategories(completion: @escaping (Result<GuestCategoryResponse, Error>) -> Void){
        
        let url = "https://kroya-api-production.up.railway.app/api/v1/category/all"
        let headers: HTTPHeaders = [
            
            "accept": "*/*",
            "content-Type": "application/json"
            
        ]
        
        AF.request(url, method: .get, headers: headers).validate()
            .responseDecodable(of: GuestCategoryResponse.self){ response in
                debugPrint(response)
                
                switch response.result {
                case .success(let apiResponse):
                    if apiResponse.statusCode == "200" {
                        print("Guest Categories retrieved successfully.")
                        completion(.success(apiResponse))
                    } else {
                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    //MARK: Get all Guest Category by Id
    func getAllGuestFoodCategoryById(category: Int, completion: @escaping (Result<GuestCategoryAllFoodById, Error>) -> Void) {
        
        // Construct the URL with the category ID
        let url = Constants.GuestFoodPopularUrl + "\(category)"
        let headers: HTTPHeaders = [
            
            "accept" : "*/*",
            "content-Type" : "application/json"
            
        ]
        
        AF.request(url, method: .get, headers: headers).validate()
            .responseDecodable(of: GuestCategoryAllFoodById.self) { response in
            
//            if let statusCode = response.response?.statusCode {
//                // Check for 404 status code and handle it gracefully
//                if statusCode == 404 {
//                    print("No foods found for the specified category ID.")
//                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "No foods found for the specified category ID."])))
//                    return
//                }
//            }
            
            // Pretty print the JSON response for debugging
            if let data = response.data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    if let prettyString = String(data: prettyData, encoding: .utf8) {
                        print("Pretty JSON Response:\n\(prettyString)")
                    }
                } catch {
                    print("Failed to convert response data to pretty JSON: \(error)")
                }
            }
                debugPrint(response)
            // Handle the response result
            switch response.result {
                
            case .success(let apiResponse):
                if let statusCode = Int(apiResponse.statusCode), statusCode == 200 {
                    completion(.success(apiResponse))
                } else {
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

