//
//  GuestFoodRecipeVM.swift
//  Kroya_UI_Project
//
//  Created by kosign on 22/11/24.
//

import Foundation
import SwiftUI

class GuestFoodRecipeVM: ObservableObject {
    
    @Published var GuestFoodRecipe: [FoodRecipeModel] = []
    @Published var GuestFoodRecipeByCuisine: [FoodRecipeModel] = []
    @Published var GuestRecipeCuisine: [CuisinesModel] = []
    
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var searchText: String = ""
    // MARK: Helper functions for loading state
    private func startLoading() {
        isLoading = true
    }
    
    private func endLoading() {
        isLoading = false
    }
    var filteredFoodRecipeList: [FoodRecipeModel] {
        //  let foodList = isChooseCuisine ? FoodSellByCategory : FoodOnSale
          if searchText.isEmpty {
              return GuestFoodRecipe
          } else {
              return GuestFoodRecipe.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
          }
      }
    
    // MARK: Get All Guest Recipe Food
    func getAllGuestRecipeFood() {
        startLoading()
        GuestFoodRecipeService.shared.getAllGuestFoodRecipe { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.GuestFoodRecipe = payload
                        self?.successMessage = "Guest Recipe food fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load guest recipe food: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
    
    // MARK: Get Guest Recipes by Cuisine
    func getRecipesByCuisine(cuisineId: Int) {
        startLoading()
        GuestFoodRecipeService.shared.getAllGuestFoodRecipeByCuisine(cuisine: cuisineId) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.GuestFoodRecipeByCuisine = payload
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load recipes: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: Get All Cuisines
       func getAllGuestCuisines() {
           self.isLoading = true
           GuestFoodRecipeService.shared.getAllGuestFoodRecipe { [weak self] result in
               DispatchQueue.main.async {
                   self?.isLoading = false
                   switch result {
                   case .success(let response):
                       if response.statusCode == "200", let payload = response.payload {
                           self?.GuestFoodRecipe = payload
                       } else {
                           self?.showError = true
                           self?.errorMessage = response.message
                       }
                   case .failure(let error):
                       self?.showError = true
                       self?.errorMessage = "Failed to load cuisines: \(error.localizedDescription)"
                   }
               }
           }
       }
}
