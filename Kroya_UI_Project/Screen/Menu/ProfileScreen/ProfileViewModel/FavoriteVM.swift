//
//  FavoriteVM.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/14/24.
//

import Foundation
 
class FavoriteVM: ObservableObject {
    @Published var favoriteFoodRecipe: [FoodRecipeModel] = []
    @Published var favoriteFoodSell: [FoodSellModel] = []
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private func startLoading() {
        isLoading = true
    }
    
    private func endLoading() {
        isLoading = false
    }
    
    func getAllFavoriteFood() {
        startLoading()
        FavoriteService.shared.fetchAllFavorite { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.favoriteFoodSell = payload.favoriteFoodSells ?? []
                        self?.favoriteFoodRecipe = payload.favoriteFoodRecipes ?? []
                        
                        self?.successMessage = "Favorite food fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to get Favorite food \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }

    // MARK: Create or Toggle a Favorite Food
    func createFavoriteFood(foodId: Int, itemType: String) {
        startLoading() // Start loading state
        
        // Call the FavoriteService with foodId and itemType
        FavoriteService.shared.saveFavoriteFood(foodId: foodId, itemType: itemType) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading() // End loading state
                switch result {
                case .success(let response):
                    if response.statusCode == "201" { // Check for successful creation
                        self?.successMessage = "Favorite food toggled successfully."
                        self?.getAllFavoriteFood() // Refresh the list of favorite foods
                    } else {
                        self?.errorMessage = response.message // Display backend error message
                    }
                    self?.showError = false
                case .failure(let error):
                    self?.errorMessage = "Failed to toggle Favorite food: \(error.localizedDescription)"
                    self?.showError = true
                }
            }
        }
    }






    
}
