//
//  UserService.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 24/10/24.
//

import Alamofire
import SwiftUI

class ProfileService {
    
    static let shared = ProfileService()
    
    // MARK: Get User Profile
    func getUserProfile(completion: @escaping (Result<UserProfileResponse, Error>) -> Void) {
        let url = Constants.KroyaUrlUser + "profile"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")"
        ]
        
        AF.request(url, method: .get, headers: headers).validate()
            .responseDecodable(of: UserProfileResponse.self) { response in
                debugPrint(response)
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
    
    //MARK: Update Profile
    func sendUpdateProfileRequest(fullName: String, phoneNumber: String, address: String, profileImageName: String, completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token not found."])
            completion(.failure(error))
            return
        }

        let url = Constants.KroyaUrlUser + "edit-profile"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]

        let parameters: [String: Any] = [
            "profileImage": profileImageName,
            "fullName": fullName,
            "phoneNumber": phoneNumber,
            "location": address
        ]

        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300) // Validate only successful responses
            .responseDecodable(of: UserSettingProfileResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.statusCode == "200", let updatedProfile = result.payload {
                        completion(.success(updatedProfile))
                    } else {
                        let error = NSError(domain: "", code: Int(result.statusCode) ?? 500, userInfo: [NSLocalizedDescriptionKey: result.message])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

}

