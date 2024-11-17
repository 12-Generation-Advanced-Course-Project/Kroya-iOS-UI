//
//  ViewAccountService.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 16/11/24.
//

import Foundation
import Alamofire


class ViewAccountService{
    static let shared = ViewAccountService()
    
    //MARK: fetch all User Data food
    func fetchAllUserDataFood(userId:Int,completion: @escaping (Result<ViewAccountResponse, Error>) -> Void){
        guard let accessToken = Auth.shared.getAccessToken() else {
            print("Error: Access token is nil.")
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])
            completion(.failure(error))
            return
        }
        
        let url = Constants.KroyaUrlUser + "foods/\(userId)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")"
        ]
        AF.request(url,method:.get,headers: headers).responseDecodable(of: ViewAccountResponse.self) { response in
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
            } else {
                print("No response data available")
            }
            debugPrint(response)
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.statusCode == "200" {
                    print("User Data  listings retrieved successfully.")
                    completion(.success(apiResponse))
                } else {
                    print("Failed to retrieved Food listings")
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
