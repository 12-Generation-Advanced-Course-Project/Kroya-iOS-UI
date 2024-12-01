//
//  GuestFoodSellService.swift
//  Kroya_UI_Project
//
//  Created by kosign on 20/11/24.
//

import Foundation
import Alamofire

class GuestFoodSellService{
    
    static let shared = GuestFoodSellService()
    
    //MARK: Get all guest food sells
    func fetchGuestFoodSell(completion: @escaping ((Result<GuestFoodSellResponse, Error>) -> Void)){
        
        let url = Constants.GuestFoodSellUrl + "/list"
        let headers: HTTPHeaders = [
            
            "accept" : "*/*",
            "content-Type" : "application/json"
            
        ]
        
        AF.request(url, method: .get , headers: headers).validate()
        
            .responseDecodable(of: GuestFoodSellResponse.self) { response in
                
                switch response.result {
                    
                case .success(let apiResponse):
                    if apiResponse.statusCode == "200" {
                        print("Fetched guest all food sell data successfully.")
                        completion(.success(apiResponse))
                    } else {
                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Request guest all food sell failed with error: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    
    //MARK: Guest get food sell by cuisine id
    func getFoodSellByCuisine(cuisine: Int, completion: @escaping (Result<GuestFoodSellCuisineResponse, Error>) -> Void) {
        
        let url = "\(Constants.guestSeelCuisine)\(cuisine)"
        let headers: HTTPHeaders = [
            
            "accept" : "*/*",
            "content-Type" : "application/json"
            
        ]
        
        AF.request(url, method: .get, headers: headers).validate()
            .responseDecodable(of: GuestFoodSellCuisineResponse.self) { response in
                switch response.result {
                    
                case .success(let apiResponse):
                    
                    print("Data apiResponse  ==> \(apiResponse)")
                    if apiResponse.statusCode == "200" {
                        print("Fetched guest food popular data successfully.")
                        completion(.success(apiResponse))
                    } else {
                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                    
                    
                case .failure(let error):
                    print("Request guest food popular failed with error: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - Get All Cuisines
    func getAllGuestCuisines(completion: @escaping (Result<CuisineResponse, Error>) -> Void) {
        
        let url = Constants.CuisineUrl + "all"
        let headers: HTTPHeaders = [
            
            "accept" : "*/*",
            "content-Type" : "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers).validate()
            .responseDecodable(of: CuisineResponse.self) { response in
                // Handle the result
                switch response.result {
                case .success(let apiResponse):
                    if let statusCode = Int(apiResponse.statusCode), statusCode == 200 {
                        completion(.success(apiResponse))
                    } else {
                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
