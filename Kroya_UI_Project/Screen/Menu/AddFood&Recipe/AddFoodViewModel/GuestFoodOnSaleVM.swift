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
    // MARK: - Helper Methods for Loading State
    private func startLoading() {
        isLoading = true
    }
    
    private func endLoading() {
        isLoading = false
    }
    var filteredFoodList: [FoodSellModel] {
         // let foodList = isChooseCuisine ? FoodSellByCategory : FoodOnSale
          if searchText.isEmpty {
              return GuestFoodOnSale
          } else {
              return GuestFoodOnSale.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
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
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load guest food sell: \(error.localizedDescription)"
                }
            }
        }
    }
}
