//
//  Foods-Service.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/11/24.
//

import SwiftUI
import Alamofire


class Foods_Service {
    static let shared = Foods_Service()
    
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
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.statusCode == "200" {
                    print("Fetched popular data successfully.")
                    completion(.success(apiResponse))
                } else {
                    let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Request Popular failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }
}

