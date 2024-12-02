//
//  Foods-Service.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/11/24.
//

import SwiftUI
import Foundation
import Alamofire


class GuestFoodPopularService {
    static let shared = GuestFoodPopularService()
    
    
    //MARK: Get all the Guest Popular Food
    func fetchGuestFoodPopular(completion: @escaping ((Result<GuestFoodPopularResponses, Error>) -> Void)) {
        
        let url = Constants.GuestFoodPopularUrl + "/popular"
        
        let headers: HTTPHeaders = [
            
            "accept": "*/*",
            "content-Type": "application/json"
            
        ]
        
        print("url  == > \(url)")
        print("header  == > \(headers)")
        
        AF.request(url ,method: .get, headers: headers).validate()
        
            .responseDecodable(of: GuestFoodPopularResponses.self) { response in
                
                print("data from api ==> \(response)")
                
                switch response.result {
                    
                case .success(let apiResponse):
                    
                    print("data apiResponse  ==> \(apiResponse)")
                    if apiResponse.statusCode == "200" {
                        print("Fetched guest food popular data successfully.")
                        completion(.success(apiResponse))
                    } else {
                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Request guest food popular failed with error: \(error)")
                    completion(.failure(error))
                }
            }
    }
    func getFoodDetailsForGuest(id: Int, itemType: String, completion: @escaping (Result<Any, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        // Construct the URL with itemType as a query parameter
        let url = Constants.FoodsUrlForGuest + "detail/\(id)?itemType=\(itemType)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url, method: .get, headers: headers).validate().responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                do {
                    if itemType == "FOOD_SELL" {
                        let apiResponse = try JSONDecoder().decode(FoodDetailSellResponse.self, from: data)
                        if apiResponse.statusCode == "200" {
                            completion(.success(apiResponse))
                        } else {
                            let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                            completion(.failure(error))
                        }
                    } else if itemType == "FOOD_RECIPE" {
                        let apiResponse = try JSONDecoder().decode(FoodDetailRecipeResponse.self, from: data)
                        if apiResponse.statusCode == "200" {
                            completion(.success(apiResponse))
                        } else {
                            let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                            completion(.failure(error))
                        }
                    } else {
                        let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unexpected item type"])
                        completion(.failure(error))
                    }
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
                
            case .failure(let error):
                if let afError = error.asAFError, let urlError = afError.underlyingError as? URLError {
                    switch urlError.code {
                    case .timedOut:
                        print("Request timed out")
                        completion(.failure(NetworkError.timeout))
                    case .notConnectedToInternet:
                        print("No internet connection")
                        completion(.failure(NetworkError.connectionLost))
                    default:
                        print("Unexpected network error: \(urlError.localizedDescription)")
                        completion(.failure(NetworkError.unexpectedError(urlError)))
                    }
                } else {
                    print("Request failed with error: \(error)")
                    completion(.failure(NetworkError.unexpectedError(error)))
                }
            }
        }
    }
    
}

