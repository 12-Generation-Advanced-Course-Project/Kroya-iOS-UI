//
//  NotificationService.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/11/24.
//

import SwiftUI
import Alamofire


class NotificationService: ObservableObject {
    
    
    static let shared = NotificationService()

    func getNotifications(completion: @escaping (Result<NotificationResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token not found."])
            completion(.failure(error))
            return
        }
        
        let url = Constants.NotificationUrl
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
      
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: NotificationResponse.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let jsonData):
                print("Response Payload: \(jsonData)") // Debug: Print the entire response
                completion(.success(jsonData))
            case .failure(let error):
                print("Error: \(error.localizedDescription)") // Debug: Print error details
                completion(.failure(error))
            }
        }

    }

}
