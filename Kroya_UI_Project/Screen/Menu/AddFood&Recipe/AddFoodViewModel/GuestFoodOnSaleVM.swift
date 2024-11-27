//
//  GuestFoodOnSaleVM.swift
//  Kroya_UI_Project
//
//  Created by kosign on 22/11/24.
//

import Foundation
import SwiftUI

class GuestFoodOnSaleVM: ObservableObject {
    
    @Published var GuestFoodOnSale: [FoodSellModel] = []
    @Published var GuestFoodSellByCategory: [FoodSellModel] = []
    
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var searchText: String = ""
    @Published var isChooseCuisine: Bool = false
    // MARK: - Helper Methods for Loading State
    private func startLoading() {
        isLoading = true
    }
    
    private func endLoading() {
        isLoading = false
    }
    var filteredFoodList: [FoodSellModel] {
        let foodList = isChooseCuisine ? GuestFoodSellByCategory : GuestFoodOnSale
        if searchText.isEmpty {
            return foodList
        } else {
            return foodList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    
    func getAllGuestFoodSell(){
        startLoading()
        GuestFoodSellService.shared.fetchGuestFoodSell { [weak self] result in
            
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.GuestFoodOnSale = payload
                        self?.successMessage = "Guest food sell fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load guest food sell: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
            
        }
    }
    
    // MARK: Get all guest food by cuisine id
    func getGuestFoodSellByCuisined(cuisineId: Int) {
        startLoading()
        GuestFoodSellService.shared.getFoodSellByCuisine(cuisine: cuisineId) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.GuestFoodSellByCategory = payload
                        self?.isChooseCuisine = true
                    } else if response.statusCode == "401" {
                        print("Unauthorized access. Check if token is required.")
                        self?.handleUnauthorizedError()
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    if let afError = error.asAFError,
                       case .responseValidationFailed(let reason) = afError,
                       case .unacceptableStatusCode(let code) = reason,
                       code == 401 {
                        print("Unauthorized access. Fallback to default data.")
                        self?.handleUnauthorizedError()
                    } else {
                        self?.showError = true
                        self?.errorMessage = "Failed to load guest food sell: \(error.localizedDescription)"
                    }
                }
            }
        }
    }

    private func handleUnauthorizedError() {
        self.GuestFoodSellByCategory = [] // Clear the data
        self.isChooseCuisine = false
        self.showError = true
        self.errorMessage = "You are not authorized to access this data."
    }


}
