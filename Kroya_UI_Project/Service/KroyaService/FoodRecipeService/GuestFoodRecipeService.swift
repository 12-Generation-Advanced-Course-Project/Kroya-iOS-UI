//
//  GuestFoodRecipeService.swift
//  Kroya_UI_Project
//
//  Created by kosign on 22/11/24.
//

import Foundation
import Alamofire

class GuestFoodRecipeService {
    
    static let shared = GuestFoodRecipeService()
    
    //MARK: GET ALL FOOD RECIPE
    func getAllGuestFoodRecipe(completion: @escaping (Result<guestFoodRecipeResponse, Error>) -> Void) {
        
        let url = Constants.GuestFoodRecipeUrl + "/list"
        let headers: HTTPHeaders = [
            
            "accept": "*/*",
            "content-Type": "application/json"
            
        ]
        
        AF.request(url, method: .get , headers: headers).validate()
            .responseDecodable(of: guestFoodRecipeResponse.self) { response in
                
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
                } else {
                    print("No response data available")
                }
                
                // Handle the result as usual
                switch response.result {
                case .success(let apiResponse):
                    if let statusCode = Int(apiResponse.statusCode), statusCode == 200 {
                        print("Get guest foodRecipe successfully.")
                        completion(.success(apiResponse))
                    } else {
                        print("Failed to retrieve guest food recipes.")
                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion(.failure(error))
                }
            }
        
    }
    
    //MARK: Get all Guest Food Recipe by Cuisine
    func getAllGuestFoodRecipeByCuisine(cuisine: Int, completion: @escaping (Result<guestFoodRecipeResponse, Error>) -> Void) {

        
        // Construct the URL with the category ID
        let url = "\(Constants.GuestFoodRecipeByCuisineUrl)\(cuisine)"
        let headers: HTTPHeaders = [
            
            "accept" : "*/*",
            "content-Type": "application/json"
            
        ]
        
        AF.request(url, method: .get, headers: headers).validate()
            .responseDecodable(of: guestFoodRecipeResponse.self) { response in
            // Print response data for debugging
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
            
            // Handle the result
            switch response.result {
            case .success(let apiResponse):
                if let statusCode = Int(apiResponse.statusCode), statusCode == 200 {
                    completion(.success(apiResponse))
                } else {
                    let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
