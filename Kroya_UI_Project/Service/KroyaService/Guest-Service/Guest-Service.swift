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
    
    
    //MARK: Get all the Popular Food
    func fetchGuestFoodPopular(completion: @escaping ((Result<GuestFoodPopularResponses, Error>) -> Void)) {
        
        let url = Constants.GuestFoodPopularUrl + "popular"
        
        AF.request(url, method: .get).validate()
            .responseDecodable(of: GuestFoodPopularResponses.self) { response in
           
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.statusCode == "200" {
                    print("Fetched guest food popular data successfully.")
                    completion(.success(apiResponse))
                } else {
                    let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                    debugPrint("KUromi", response)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Request guest food popular failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }
}

