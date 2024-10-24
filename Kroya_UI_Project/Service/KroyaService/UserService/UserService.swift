//
//  UserService.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 24/10/24.
//

import Alamofire
import SwiftUI

class UserService {
    static let shared = UserService()
    
    //MARK: Get User Profile
    func getUserProfile(completion: @escaping (Result<UserProfileResponse, Error>) -> Void) {
        let url = Constants.KroyaUrlUser + "profile"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")"
        ]
        
        AF.request(url, method: .get, headers: headers).validate()
            .responseDecodable(of: UserProfileResponse.self) { response in
                debugPrint(response)
                switch response.result {
                case .success(let apiResponse):
                    if let statusCode = Int(apiResponse.statusCode), statusCode == 200 {
                        print("User profile retrieved successfully.")
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
}

