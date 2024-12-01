//
//  FoodSell-Service.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/11/24.
//
import Alamofire
import SwiftUI

class FoodSellService {
    static let shared = FoodSellService()
    
    //MARK:  Fetch on card food sell
    func fetchAllCardFood(completion: @escaping (Result<foodSellResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token not found."])
            completion(.failure(error))
            return
        }
        let url = Constants.FoodSellUrl + "list"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url, method: .get, headers: headers).validate()
            .responseDecodable(of:foodSellResponse.self) { response in
                switch response.result{
                case .success(let apiResponse):
                    if let statusCode = Int(apiResponse.statusCode), statusCode == 200 {
                        print("User profile retrieved successfully.")
                        print("This is the user profile:\(String(describing: apiResponse.payload))")
                        completion(.success(apiResponse))
                    } else {
                        print("Failed to retrieve user profile.")
                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    
    //MARK: Get all Food Sell by Category
    func getAllFoodSellByCategory(category: Int, completion: @escaping (Result<foodSellResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        let url = "\(Constants.FoodSellCategoryUrl)\(category)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: foodSellResponse.self) { response in
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
    
    // MARK: Post-Food-Sell
    func postFoodSell(
        _ foodSellRequest: FoodSellRequest,
        foodRecipeId: Int,
        currencyType: String,
        completion: @escaping (Result<SaveFoodSellResponse, NetworkError>) -> Void
    ) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            completion(.failure(.noAccessToken))
            return
        }
        
        let url = "\(Constants.FoodSellUrl)post-food-sell?foodRecipeId=\(foodRecipeId)&currencyType=\(currencyType)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "dateCooking": foodSellRequest.dateCooking,
            "amount": foodSellRequest.amount,
            "price": foodSellRequest.price,
            "location": foodSellRequest.location
        ]
        
        // Send POST request
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: SaveFoodSellResponse.self) { response in
                debugPrint(response)
                switch response.result {
                case .success(let apiResponse):
                    if let statusCode = Int(apiResponse.statusCode), statusCode == 201 {
                        print("Food sell created successfully.")
                        completion(.success(apiResponse))
                    } else {
                        print("Failed to create food sell.")
                        completion(.failure(.serverError(message: apiResponse.message)))
                    }
                    
                case .failure(let error):
                    if let afError = error.asAFError {
                        switch afError {
                        case .sessionTaskFailed(let underlyingError):
                            if (underlyingError as? URLError)?.code == .timedOut {
                                completion(.failure(.timeout))
                            } else if (underlyingError as? URLError)?.code == .notConnectedToInternet {
                                completion(.failure(.connectionLost))
                            } else {
                                completion(.failure(.unexpectedError(underlyingError)))
                            }
                        default:
                            completion(.failure(.unexpectedError(error)))
                        }
                    }
                }
            }
    }

    
    
    
    //MARK: Get Search Food Sell By Name
    func getSearchFoodSellByName(searchText: String, completion: @escaping (Result<foodSellResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        // Construct the URL with the search query
        let url = "\(Constants.FoodSellUrl)search?name=\(searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: foodSellResponse.self) { response in
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
    
    // MARK: - Get All Cuisines
    func getAllCuisines(completion: @escaping (Result<CuisineResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }

        let url = Constants.CuisineUrl + "all"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]

        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: CuisineResponse.self) { response in
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


