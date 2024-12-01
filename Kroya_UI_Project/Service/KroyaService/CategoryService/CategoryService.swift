//
//  CategoryService.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/11/24.
//

import SwiftUI
import Alamofire

class CategoryService {
    
    static let shared = CategoryService()
    
    // MARK: Get All Categories
    func getAllCategory(completion: @escaping (Result<CategoryResponses, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        let url = Constants.CategoryUrl + "all"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        AF.request(url, method: .get, headers: headers).validate()
            .responseDecodable(of: CategoryResponses.self) { response in
             
                switch response.result {
                case .success(let apiResponse):
                    if apiResponse.statusCode == "200" {
                        print("Categories retrieved successfully.")
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
    
    //MARK: Get all Category by Id
    func getAllCategoryById(category: Int, completion: @escaping (Result<getAllFoodCategoryResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        // Construct the URL with the category ID
        let url = Constants.FoodsUrl + "\(category)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: getAllFoodCategoryResponse.self) { response in
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

