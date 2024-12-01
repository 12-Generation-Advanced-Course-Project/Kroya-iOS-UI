//
//  SaleReportService.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 21/11/24.
//


import SwiftUI
import Alamofire

class SaleReportService {
    static let shared = SaleReportService()
    
    func getSaleReport(date: String, completion: @escaping (Result<SaleReportResponse, Error>) -> Void) {
        guard let accessToken = Auth.shared.getAccessToken() else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token not found."])
            completion(.failure(error))
            return
        }
        
        // Ensure no double slashes in the URL
        let baseUrl = Constants.SalesReportUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let url = "\(baseUrl)/\(date)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        print("Corrected Request URL: \(url)")
        print("Access Token: \(accessToken)")
        
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: SaleReportResponse.self) { response in
            switch response.result {
            case .success(let payload):
                completion(.success(payload))
            case .failure(let error):
                print("Request failed: \(error)")
                completion(.failure(error))
            }
        }
    }

}
