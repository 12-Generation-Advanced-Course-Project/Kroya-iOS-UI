import Foundation
import Alamofire
import Combine

class AddressViewModel: ObservableObject {
    @Published var addresses: [Address] = []
    @Published var isLoading: Bool = false
    @Published var defaultAddressId: Int? // Store the ID of the default address
    @Published var currentUserProfileLocation: String? // New property for profile location
    
    func fetchData() {
        isLoading = true
        let dispatchGroup = DispatchGroup()
        var profileLocation: String?
        
        dispatchGroup.enter()
        fetchUserProfile { location in
            profileLocation = location
            print("Fetched profile location: \(profileLocation ?? "nil")")
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchAddresses {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.isLoading = false
            print("Fetched addresses: \(self.addresses)")
            if let location = profileLocation {
                if let matchingAddress = self.addresses.first(where: { $0.addressDetail.starts(with: location) }) {
                    self.defaultAddressId = matchingAddress.id
                    print("Default address ID set to: \(self.defaultAddressId ?? -1)")
                } else {
                    print("No matching address found for profile location: \(location)")
                }
            }
        }
    }

    
    // Fetch user profile to get the default address
    func fetchUserProfile(completion: @escaping (String?) -> Void) {
        let url = "https://kroya-api-production.up.railway.app/api/v1/user/profile"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: UserProfileResponse.self) { response in
            switch response.result {
            case .success(let profileResponse):
                completion(profileResponse.payload?.location)
            case .failure(let error):
                print("Failed to fetch user profile: \(error.localizedDescription)")
                completion(nil)
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

    func fetchAddresses(completion: @escaping () -> Void) {
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
                    
//                    // Fetch user profile and compare
//                    self.fetchUserProfile { userProfileLocation in
//                        guard let profileLocation = userProfileLocation else { return }
//                        
//                        // Mark the default address if it matches the profile location
//                        if let matchingAddress = self.addresses.first(where: { $0.addressDetail == profileLocation }) {
//                            self.defaultAddressId = matchingAddress.id
//                        }
//                    }
                    
                case .failure(let error):
                    print("Failed to fetch addresses: \(error.localizedDescription)")
                }
                
                completion()
                
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
    
    func saveAddress(_ address: Address, completion: @escaping (Result<Address, Error>) -> Void) {
        let url = "https://kroya-api-production.up.railway.app/api/v1/address/create"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]
        
        // Insert request
        AF.request(url, method: .post, parameters: address, encoder: JSONParameterEncoder.default, headers: headers).responseDecodable(of: SingleAddressResponse.self) { response in
            switch response.result {
            case .success(let addressResponse):
                var createdAddress = addressResponse.payload
                print("Received Address ID: \(createdAddress.id)")
                
                // Append ID conditionally
                if !createdAddress.addressDetail.contains("(ID: \(createdAddress.id))") {
                    createdAddress.addressDetail += " (ID: \(createdAddress.id))"
                }
                
                // Update the address with modified detail
                self.updateAddress(createdAddress) { updateResult in
                    switch updateResult {
                    case .success:
                        print("Address updated successfully with modified detail")
                        completion(.success(createdAddress))
                    case .failure(let error):
                        print("Failed to update address: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
                
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
        var updatedAddress = address

        // Ensure ID is appended only once
        if !updatedAddress.addressDetail.contains("(ID: \(updatedAddress.id))") {
            updatedAddress.addressDetail += " (ID: \(updatedAddress.id))"
        }

        let url = "https://kroya-api-production.up.railway.app/api/v1/address/update/\(address.id)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]

        // Perform the address update
        AF.request(url, method: .put, parameters: updatedAddress, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success:
                print("Address update request was successful.")

                // Check if the address is marked as default
                if self.defaultAddressId != address.id {
                    print("Address is marked as default. Triggering profile update.")
                    self.updateUserProfileLocation(location: address.addressDetail) { result in
                        switch result {
                        case .success:
                            print("User profile location updated successfully.")
                            completion(.success(()))
                        case .failure(let error):
                            print("Failed to update user profile location: \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    }
                } else {
                    print("Address is not marked as default. Skipping profile update.")
                    completion(.success(()))
                }
            case .failure(let error):
                print("Address update request failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }




    
    private func updateUserProfileLocation(location: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "https://kroya-api-production.up.railway.app/api/v1/user/edit-profile"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Auth.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]
        // Fetch valid values for these fields if available
        let parameters: [String: String] = [
            "profileImage": "string", // Use actual value
            "fullName": "string",     // Use actual value
            "phoneNumber": "01234567890",  // Ensure this is valid
            "location": location
        ]

        AF.request(url, method: .put, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                print("Response data from user profile update: \(responseString)")
            }
            switch response.result {
            case .success:
                print("Profile update request was successful.")
                completion(.success(()))
            case .failure(let error):
                print("Profile update request failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

}
