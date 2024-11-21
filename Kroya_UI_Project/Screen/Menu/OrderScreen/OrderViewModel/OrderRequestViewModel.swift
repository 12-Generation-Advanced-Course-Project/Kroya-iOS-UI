//
//  OrderRequestViewModel.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 19/11/24.
//

import SwiftUI
import Alamofire

class OrderRequestViewModel: ObservableObject {
    
    @Published var ordersRequestModel: [OrderRequestModel] = []
    
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isUpdate: Bool = false
    
    // MARK: - Helper Methods for Loading State
    private func startLoading() {
        isLoading = true
    }
    
    private func endLoading() {
        isLoading = false
    }
    
    
    // MARK: Fetch Orders for Seller by Id
    func fetchOrderForSellerById(sellerId: Int) {
        self.startLoading()
        OrderRequestService.shared.getOrderForSellerById(sellerId: sellerId) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.ordersRequestModel = payload
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load orderRequeat: \(error.localizedDescription)"
                }
            }
        }
    }
    
    
}
