//
//  CuisineService.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/11/24.
//

import SwiftUI
import Alamofire

class CuisineService {
    static let shared = CuisineService()
    
    // MARK: Get Cuisine
    func getCuisine(completiion: @escaping (Result <CuisineResponse , Error>) -> Void){
        let url = Constants.CuisineUrl + "all"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")"
        ]
        
        AF.request(url, method: .get , headers: headers).validate()
            .responseDecodable(of: CuisineResponse.self){ response in
                debugPrint(response)
                switch response.result{
                case .success(let apiResponse):
                    if let statusCode = Int(apiResponse.statusCode), statusCode == 200{
                        print("Cuisines retrieved successfully.")
                        completiion(.success(apiResponse))
                    } else {
                        print("Failed to retrieved cuisines")
                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completiion(.failure(error))
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completiion(.failure(error))
                }
            }
    }
}
