//
//  FavoriteService.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/11/24.
//

import SwiftUI
import Alamofire

class FavoriteService{
    static let shared = FavoriteService()
    
    func fetchAllFavorite(completion: @escaping (Result<getAllFavoriteResponse, Error>) -> Void){
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        let url = Constants.FavoriteFoodUrl + "all"
        let herders: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        AF.request(url, method: .get, headers: herders).validate().responseDecodable( of: getAllFavoriteResponse.self){ response in
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.statusCode == "200" {
                    print("Favorite Response: \(apiResponse)")
                    completion(.success(apiResponse))
                }
            case .failure(let error):
                print("Request favorite failed with error: \(error)")
                completion(.failure(error))
            }
        }
        
    }
    
    
    // MARK: - Post Favorite Food
    func saveFavoriteFood(foodId: Int, itemType: String, completion: @escaping (Result<AddFavouriteResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        let url = Constants.FavoriteFoodUrl + "add-favorite"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        let parameters: [String: Any] = ["foodId": foodId, "itemType": itemType]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseDecodable(of: AddFavouriteResponse.self) { response in
                debugPrint(response)
                switch response.result {
                case .success(let saveResponse):
                    print("Favorite Food created successfully: \(saveResponse)")
                    completion(.success(saveResponse))
                case .failure(let error):
                    print("Error creating Favorite Food: \(error)")
                    completion(.failure(error))
                }
            }
      }
    
    // Remove Favorite Food
    func removeFavoriteFood(foodId: Int, itemType: String, completion: @escaping (Result<RemoveFavoriteResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }

        let url = Constants.FavoriteFoodUrl + "remove-favorite"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        let parameters: [String: Any] = ["foodId": foodId, "itemType": itemType]

        AF.request(url, method: .delete, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseDecodable(of: RemoveFavoriteResponse.self) { response in
                switch response.result {
                case .success(let removeResponse):
                    completion(.success(removeResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - Get Foods by Name
    func fetchFavoriteByName(searchText: String, completion: @escaping (Result<getAllFavoriteResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
    
        let url = "\(Constants.FavoriteFoodUrl)search?name=\(searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        // Send the request
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: getAllFavoriteResponse.self) { response in
            // Handle the response
            switch response.result {
            case .success(let apiResponse):
                if let statusCode = Int(apiResponse.statusCode), statusCode == 200 {
                    completion(.success(apiResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

