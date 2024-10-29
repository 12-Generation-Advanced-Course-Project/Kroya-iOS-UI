//
//  AdressViewModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 7/10/24.
//

import Foundation
import Alamofire
import SwiftUI
import Combine

class AddressViewModel: ObservableObject {
    @Published var addresses: [Address] = []
   
    @Published var selectedAddress: Address?
    @ObservedObject var userStore: UserStore
    init(userStore: UserStore) {
        self.userStore = userStore
    }

    // Save address through the service
    func saveAddress(addressDetail: String, specificLocation: String, tag: String, latitude: Double, longitude: Double) {
        let addressRequest = AddressRequest(addressDetail: addressDetail, specificLocation: specificLocation, tag: tag, latitude: latitude, longitude: longitude)

        GoogleMapsService.shared.saveAddressToBackend(addressRequest: addressRequest) { [weak self] result in
            switch result {
            case .success(let response):
                if let savedAddress = response.payload {
                    DispatchQueue.main.async {
                        self?.addresses.append(savedAddress)
                        self?.selectedAddress = savedAddress // Set newly saved address as selected
                        print("Address saved successfully: \(savedAddress)")
                    }
                }
            case .failure(let error):
                print("Failed to save address: \(error.localizedDescription)")
            }
        }
    }

    // Fetch all addresses through the service
    func fetchAllAddresses() {
        GoogleMapsService.shared.fetchAllAddresses { [weak self] result in
            switch result {
            case .success(let fetchedAddresses):
                DispatchQueue.main.async {
                    self?.addresses = fetchedAddresses
                    self?.selectedAddress = fetchedAddresses.last // Automatically select the last address
                    print("Fetched addresses: \(fetchedAddresses)")
                }
            case .failure(let error):
                print("Failed to fetch addresses: \(error.localizedDescription)")
            }
        }
    }

    // Delete an address locally
    func deleteAddress(id: Int) {
        GoogleMapsService.shared.deleteAddress(id: id) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    if let index = self?.addresses.firstIndex(where: { $0.id == id }) {
                        self?.addresses.remove(at: index)
                        self?.selectedAddress = self?.addresses.last // Set selectedAddress to the latest address
                        print("Address deleted successfully: ID \(id)")
                    }
                }
            case .failure(let error):
                print("Failed to delete address: \(error.localizedDescription)")
            }
        }
    }


    // MARK: Update Address by Id
    func updateAddress(id: Int, address: Address) {
        let addressRequest = AddressRequest(
            addressDetail: address.addressDetail,
            specificLocation: address.specificLocation,
            tag: address.tag,
            latitude: address.latitude,
            longitude: address.longitude
        )
        
        GoogleMapsService.shared.updateGoogleMaps(id: id, addressRequest: addressRequest) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    // Ensure the array is updated completely to refresh the view
                    if let index = self?.addresses.firstIndex(where: { $0.id == id }) {
                        self?.addresses[index] = address
                        self?.addresses = Array(self?.addresses ?? []) // Reassign a new array to trigger update
                        print("Address updated successfully.")
                    } else {
                        print("Address not found in the list.")
                    }
                }
            case .failure(let error):
                print("Failed to update address: \(error.localizedDescription)")
            }
        }
    }

}
