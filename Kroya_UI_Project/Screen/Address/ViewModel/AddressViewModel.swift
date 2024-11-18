import Foundation
import Alamofire
import Combine

class AddressViewModel: ObservableObject {
    @Published var addresses: [Address] = []
    @Published var isLoading: Bool = false
    @Published var defaultAddressId: Int? // Store the ID of the default address
    @Published var currentUserProfileLocation: String? // New property for profile location

    func fetchAddresses() {
        isLoading = true // Start loading before the request
        let url = "https://kroya-api-production.up.railway.app/api/v1/address/list"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: AddressResponse.self) { response in
            DispatchQueue.main.async {
                self.isLoading = false // Stop loading after response
                
                switch response.result {
                case .success(let addressResponse):
                    self.addresses = addressResponse.payload
                    print("Fetched addresses: \(addressResponse.payload)")
                case .failure(let error):
                    print("Failed to fetch addresses: \(error.localizedDescription)")
                }
                
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
                }
            }
        }
    }
    
    func saveAddress(_ address: Address, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "https://kroya-api-production.up.railway.app/api/v1/address/create"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]

        AF.request(url, method: .post, parameters: address, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteAddress(id: Int) {
        let url = "https://kroya-api-production.up.railway.app/api/v1/address/delete/\(id)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")",
            "Accept": "*/*"
        ]
        
        isLoading = true // Show loading indicator
        AF.request(url, method: .delete, headers: headers).response { response in
            DispatchQueue.main.async {
                self.isLoading = false // Stop loading after response
                
                switch response.result {
                case .success:
                    // Remove the deleted address from the local list
                    self.addresses.removeAll { $0.id == id }
                    print("Address deleted successfully")
                case .failure(let error):
                    print("Failed to delete address: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchAddressById(id: Int, completion: @escaping (Result<Address, Error>) -> Void) {
        let url = "https://kroya-api-production.up.railway.app/api/v1/address/\(id)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: SingleAddressResponse.self) { response in
            switch response.result {
            case .success(let addressResponse):
                completion(.success(addressResponse.payload))
            case .failure(let error):
                completion(.failure(error))
            }
            
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
            }
        }
    }
    
    func updateAddress(_ address: Address, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "https://kroya-api-production.up.railway.app/api/v1/address/update/\(address.id)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]

        AF.request(url, method: .put, parameters: address, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
