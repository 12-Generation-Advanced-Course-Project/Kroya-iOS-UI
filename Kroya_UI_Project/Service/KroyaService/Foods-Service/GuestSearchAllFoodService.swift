//
//  GuestSearchAllFoodService.swift
//  Kroya_UI_Project
//
//  Created by PVH_003 on 26/11/24.
//

import Foundation
import Foundation
import Alamofire

class GuestSearchAllFoodService {
    
    static let shared = GuestSearchAllFoodService()
    
    //MARK: Get all guest food (search)
    func fetchGuestSearchAllFood(completion: @escaping ((Result<guestSearchAllFoodResponse, Error>) -> Void )) {
        
        let url = Constants.GuestSearchAllFoodUrl + "/foods/list"
        let headers: HTTPHeaders = [
            
            "accept" : "*/*",
            "content-Type" : "application/json"
            
        ]
        
        AF.request(url, method: .get , headers: headers).validate()
            .responseDecodable(of: guestSearchAllFoodResponse.self) { response in
                debugPrint(response)
                switch response.result {
                case .success(let apiResponse):
                    if apiResponse.statusCode == "200" {
                        print("Fetched guest search all food list successfully.")
                        completion(.success(apiResponse))
                    } else {
                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Request guest all food list failed with error: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    //MARK: Get all guest food search by name
    func fetchGuestSearchFoodByName(searchText: String, completion: @escaping (Result<guestSearchAllFoodResponse, Error>) -> Void) {
        
        let url = "\(Constants.GuestSearchAllFoodByNameUrl)search?name=\(searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        let headers: HTTPHeaders = [
            "accept" : "*/*",
            "content-Type" : "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers).validate()
            .responseDecodable(of:guestSearchAllFoodResponse.self) { response in
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
                    completion(.failure(error))
                }
            }
    }
}
