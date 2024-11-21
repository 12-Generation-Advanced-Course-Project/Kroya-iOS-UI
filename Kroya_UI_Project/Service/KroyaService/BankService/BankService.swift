//
//  BankService.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/11/24.
//

// BankService.swift

import SwiftUI
import Alamofire

class BankService {
    
    static let shared = BankService()
    
    // MARK: Get Token for Access into WeBill365
    func weBill365Token(clientID: String, clientSecret: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let url = "https://apidev.webill365.com/kh/api/wbi/client/v1/auth/token"
        
        // Parameters
        let parameters: [String: Any] = [
            "client_id": clientID,
            "client_secret": clientSecret
        ]
        
        // Headers
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "accept": "*/*"
        ]
        
        // Alamofire Request
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: WeBill365Response.self) { response in
            // Handle the response
            debugPrint(response)
            switch response.result {
            case .success(let data):
                if let accessToken = data.data?.accessToken {
                    // Save the access token using Auth class
                    Auth.shared.setWeBillCredentials(clientId: clientID, secretId: clientSecret, webillToken: accessToken)
                    print("Access token retrieved and saved successfully.")
                    completion(.success(()))
                } else {
                    let errorMessage = data.status?.message ?? "Failed to retrieve access token."
                    let error = NSError(domain: "", code: data.status?.code ?? -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }
}
