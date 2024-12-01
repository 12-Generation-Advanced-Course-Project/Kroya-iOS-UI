//
//  Foods-Service.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/11/24.
//

import SwiftUI
import Foundation
import Alamofire


class Foods_Service {
    static let shared = Foods_Service()
    
    
    //MARK: Get all the Popular Food
    func fetchAllPopular(completion: @escaping ((Result<popularResponse, Error>) -> Void)) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        let url = Constants.PopularDishes + "popular"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: popularResponse.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.statusCode == "200" {
                    print("Fetched popular data successfully.")
                    completion(.success(apiResponse))
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

    //MARK: Food Details for Recipe or Sell
    func getFoodDetails(id: Int, itemType: String, completion: @escaping (Result<Any, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        // Construct the URL with itemType as a query parameter
        let url = Constants.FoodsUrl + "detail/\(id)?itemType=\(itemType)"
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
    
    
    //MARK: Get all List Food
    func fetchAllListFood(completion: @escaping ((Result<foodListResponse, Error>) -> Void)) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        let url = Constants.FoodsUrl + "list"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: foodListResponse.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.statusCode == "200" {
                    print("Fetched food list successfully.")
                    completion(.success(apiResponse))
                } else {
                    let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
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
    
    // MARK: - Get Foods by Name
    func fetchFoodByName(searchText: String, completion: @escaping (Result<foodListResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
    
        let url = "\(Constants.FoodsUrl)search?name=\(searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        // Send the request
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: foodListResponse.self) { response in
            // Debugging: Print response data
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
            
            // Handle the response
            switch response.result {
            case .success(let apiResponse):
                if let statusCode = Int(apiResponse.statusCode), statusCode == 200 {
                    completion(.success(apiResponse))
                } else {
                    let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
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

