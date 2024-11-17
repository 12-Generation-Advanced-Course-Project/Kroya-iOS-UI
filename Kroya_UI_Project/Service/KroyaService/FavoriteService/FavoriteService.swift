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
                } else {
                    let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Request favorite failed with error: \(error)")
                completion(.failure(error))
            }
        }
        
    }
    
    
    // MARK: - Post Favorite Food
    func saveFavoriteFood(foodId: Int, itemType: String, completion: @escaping (Result<getAllFavoriteResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        let url = Constants.FavoriteFoodUrl + "add-favorite"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let parameters: [String: Any] = [
            "foodId": foodId,
            "itemType": itemType
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseDecodable(of: getAllFavoriteResponse.self) { response in
                if let data = response.data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                        if let string = String(data: prettyData, encoding: .utf8) {
                            print("JSON Response For Post Favorite Food:\n\(string)")
                        }
                    } catch {
                        print("Failed to convert response data to Favorite JSON: \(error)")
                    }
                }
                
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


}

