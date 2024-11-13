//
//  DeviceTokenService.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 12/11/24.
//

import Alamofire
import Foundation

class DeviceTokenService {
    
    static let shared = DeviceTokenService()
    
    // MARK: Add Device Token
    func addDeviceToken(deviceToken: String, completion: @escaping (Result<DeviceTokenResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        let url = Constants.KroyaUrlUser + "device-token"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = ["deviceToken": deviceToken]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: DeviceTokenResponse.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    if apiResponse.statusCode == "200" {
                        print("Device Token saved successfully.")
                        completion(.success(apiResponse))
                    } else {
                        print("Failed to save Device Token.")
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
