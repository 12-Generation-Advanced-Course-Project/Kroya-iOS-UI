//
//  AdressViewModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 7/10/24.
//

import Foundation
import Alamofire
import SwiftUI

class AddressViewModel: ObservableObject {
    
    @Published var addresses: [Address] = []
    @ObservedObject var userStore: UserStore
    
    init(userStore: UserStore) {
        self.userStore = userStore
    }

    func addNewAddress(addressDetail: String, specificLocation: String, tag: String) {
        let newAddress = Address(id: addresses.count + 1, addressDetail: addressDetail, specificLocation: specificLocation, tag: tag)
        addresses.append(newAddress)
        
        // Ensure that userStore.user is not nil before updating the address
        if userStore.user == nil {
            userStore.setUser(email: "default@user.com")
        }
        
        // Update UserStore with the selected address
        userStore.user?.address = specificLocation
        print("This is Address: \(String(describing: userStore.user?.address))")
        print("Address Added Locally: \(newAddress)")
        
        // Optionally, sync the new address with the backend API
        // saveAddressToBackend(addressDetail: addressDetail, specificLocation: specificLocation, tag: tag)
    }


    
    // Save address to backend API using Alamofire
    func saveAddressToBackend(addressDetail: String, specificLocation: String, tag: String) {
        let addressRequest = AddressRequest(addressDetail: addressDetail, specificLocation: specificLocation, tag: tag)
        
        let endpoint = "https://your-backend-api.com/api/v1/addAddressDelivery"
        
        AF.request(endpoint, method: .post, parameters: addressRequest, encoder: JSONParameterEncoder.default)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    print("Address saved successfully to backend!")
                case .failure(let error):
                    print("Failed to save address to backend: \(error)")
                }
            }
    }
    
    // Fetch all addresses from the backend
    func fetchAllAddresses() {
        let endpoint = "https://your-backend-api.com/api/v1/addresses"
        
        AF.request(endpoint, method: .get)
            .validate()
            .responseDecodable(of: ApiResponse1<[Address]>.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    self.addresses = apiResponse.payload
                    print("Fetched Addresses: \(self.addresses)")
                case .failure(let error):
                    print("Failed to fetch addresses: \(error)")
                }
            }
    }
    
    // Simulate fetching addresses (for now, local fetch)
    func fetchLocalAddresses() {
        print("Fetched Addresses: \(addresses)")
    }
    
    // Method to delete an address
    func deleteAddress(id: Int) {
        if let index = addresses.firstIndex(where: { $0.id == id }) {
            addresses.remove(at: index)
            print("Address \(id) deleted.")
        }
    }
}
