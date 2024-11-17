////
////  GoogleMapsService.swift
////  Kroya_UI_Project
////
////  Created by Ounbonaliheng on 25/10/24.
////
//
//import Alamofire
//import Foundation
//
//class GoogleMapsService {
//    static let shared = GoogleMapsService()
//
//    // Save address to backend API
//    func saveAddressToBackend(addressRequest: AddressRequest, completion: @escaping (Result<AddressResponseApi, Error>) -> Void) {
//        let endpoint = Constants.KroyaAddress + "create"
//        guard let accessToken = Auth.shared.getAccessToken() else {
//            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token not found."])
//            completion(.failure(error))
//            return
//        }
//        
//        
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(accessToken)",
//            "Content-Type": "application/json"
//        ]
//
//        // Make the API request
//        AF.request(endpoint, method: .post, parameters: addressRequest, encoder: JSONParameterEncoder.default, headers: headers)
//            .validate()
//            .responseDecodable(of: AddressResponseApi.self) { response in
//                debugPrint(response)
//                switch response.result {
//                case .success(let addressResponse):
//                    if let address = addressResponse.payload {
//                        print("Address saved successfully: \(address)")
//                        completion(.success(addressResponse))
//                    } else {
//                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid address response from backend."])
//                        completion(.failure(error))
//                    }
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }
//
//    // Fetch all addresses
//    func fetchAllAddresses(completion: @escaping (Result<[Address], Error>) -> Void) {
//        
//        guard let accessToken = Auth.shared.getAccessToken() else {
//            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token not found."])
//            completion(.failure(error))
//            return
//        }
//
//        let endpoint = Constants.KroyaAddress + "list"
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(accessToken)"
//        ]
//
//        AF.request(endpoint, method: .get, headers: headers)
//            .validate()
//            .responseDecodable(of: AddressResponse<[Address]>.self) { response in
//                debugPrint(response)
//                switch response.result {
//                case .success(let apiResponse):
//                    if let addresses = apiResponse.payload {
//                        completion(.success(addresses))
//                    } else {
//                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "No addresses found."])
//                        completion(.failure(error))
//                    }
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }
//    //MARK: Delete Address
//    func deleteAddress(id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let accessToken = Auth.shared.getAccessToken() else {
//            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token not found."])
//            completion(.failure(error))
//            return
//        }
//        let endpoint = Constants.KroyaAddress + "delete/\(id)"
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(accessToken)",
//        ]
//        AF.request(endpoint, method: .delete, headers: headers)
//            .validate()
//            .response { response in
//                switch response.result {
//                case .success:
//                    print("Address deleted successfully.")
//                    completion(.success(()))
//                case .failure(let error):
//                    print("Failed to delete address: \(error.localizedDescription)")
//                    completion(.failure(error))
//                }
//            }
//    }
//    //MARK: Update google Maps
//    func updateGoogleMaps(id: Int, addressRequest: AddressRequest, completion: @escaping (Result<AddressResponseApi, Error>) -> Void) {
//        guard let accessToken = Auth.shared.getAccessToken() else {
//            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token not found."])
//            completion(.failure(error))
//            return
//        }
//        let endpoint = Constants.KroyaAddress + "update/\(id)"
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(accessToken)",
//            "Content-Type": "application/json"
//        ]
//
//        AF.request(endpoint, method: .put, parameters: addressRequest, encoder: JSONParameterEncoder.default, headers: headers)
//            .validate()
//            .responseDecodable(of: AddressResponseApi.self) { response in
//                debugPrint(response)
//                switch response.result {
//                case .success(let addressResponse):
//                    if let address = addressResponse.payload {
//                        print("Address saved successfully: \(address)")
//                        completion(.success(addressResponse))
//                    } else {
//                        let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid address response from backend."])
//                        completion(.failure(error))
//                    }
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }
//    
//}
