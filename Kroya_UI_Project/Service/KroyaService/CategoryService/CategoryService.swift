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
                debugPrint(response)
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
                    print("Request failed with error: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    
    
    
    //MARK: Get all Category by Id
//    func getAllCategoryById(category: Int, completion: @escaping (Result<CategoryResponses, Error>) -> Void) {
//        guard let accessToken = Auth.shared.getAccessToken() else {
//            print("Error: Access token is nil.")
//            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
//            completion(.failure(error))
//            return
//        }
//        
//        // Construct the URL with the category ID
//        let url = "\(Constants.CategoryByIdUrl)\(category)"
//        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
//        
//        AF.request(url, method: .get, headers: headers).validate()
//            .responseDecodable(of: CategoryResponses.self) { response in
//                debugPrint(response)
//                switch response.result {
//                case .success(let apiResponse):
//                    if apiResponse.statusCode == "200" {
//                        print("Categories retrieved successfully.")
//                        completion(.success(apiResponse))
//                    } else {
//                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
//                        completion(.failure(error))
//                    }
//                case .failure(let error):
//                    print("Request failed with error: \(error)")
//                    completion(.failure(error))
//                }
//            }
//    }
    
    
    //MARK: Get all Category by Id
    func getAllCategoryById(category: Int, completion: @escaping (Result<getAllFoodCategoryResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        // Construct the URL with the category ID
        let url = "\(Constants.CategoryByIdUrl)\(category)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        AF.request(url, method: .get, headers: headers).validate()
            .responseDecodable(of: getAllFoodCategoryResponse.self) { response in
           
                switch response.result {
                case .success(let apiResponse):
                    if apiResponse.statusCode == "200" {
                        print("Categories by ID retrieved successfully.")
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

