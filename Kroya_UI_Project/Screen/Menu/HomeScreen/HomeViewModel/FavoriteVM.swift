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
    
    // MARK: Create a New Recipe
    func createFavoriteFood(from favoriteFoodRequest: FavoriteRequest) {
        startLoading()
        FavoriteService.shared.saveFavoriteFood(favoriteFoodRequest) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "201", let createdFavoriteFood = response.payload{
                        self?.successMessage = "Favorite food created successfully with ID: \(createdFavoriteFood)"
                        self?.getAllFavoriteFood()
                    } else {
                        self?.successMessage = "Favorite food created successfully"
                    }
                    self?.showError = false
                case .failure(let error):
                    self?.errorMessage = "Failed to create Favorite food: \(error.localizedDescription)"
                    self?.showError = true
                }
            }
        }
    }
    
}
