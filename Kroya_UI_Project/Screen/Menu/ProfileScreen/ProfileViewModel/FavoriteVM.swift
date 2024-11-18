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

    func removeFavorite(foodId: Int, itemType: String) {
        FavoriteService.shared.removeFavoriteFood(foodId: foodId, itemType: itemType) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        if itemType == "FOOD_RECIPE" {
                            self?.favoriteFoodRecipe.removeAll { $0.id == foodId }
                        } else if itemType == "FOOD_SELL" {
                            self?.favoriteFoodSell.removeAll { $0.id == foodId }
                        }
                        print("Favorite removed successfully.")
                    } else {
                        print("Error: \(response.message)")
                    }
                case .failure(let error):
                    print("Failed to remove favorite: \(error.localizedDescription)")
                }
            }
        }
    }

//    // MARK: Create or Toggle a Favorite Food
//    func toggleFavorite(foodId: Int, itemType: String, isCurrentlyFavorite: Bool) {
//            isLoading = true
//            if isCurrentlyFavorite {
//                // Remove from favorite
//                FavoriteService.shared.removeFavoriteFood(foodId: foodId, itemType: itemType) { [weak self] result in
//                    DispatchQueue.main.async {
//                        self?.isLoading = false
//                        switch result {
//                        case .success(let response):
//                            if response.statusCode == "200" {
//                                self?.successMessage = response.message
//                                print("Removed from favorites successfully.")
//                            } else {
//                                self?.showError = true
//                                self?.errorMessage = response.message
//                            }
//                        case .failure(let error):
//                            self?.showError = true
//                            self?.errorMessage = "Failed to remove favorite: \(error.localizedDescription)"
//                            print("Error: \(error.localizedDescription)")
//                        }
//                    }
//                }
//            } else {
//                // Add to favorite
//                FavoriteService.shared.saveFavoriteFood(foodId: foodId, itemType: itemType) { [weak self] result in
//                    DispatchQueue.main.async {
//                        self?.isLoading = false
//                        switch result {
//                        case .success(let response):
//                            if response.statusCode == "201" {
//                                self?.successMessage = response.message
//                                print("Added to favorites successfully.")
//                            } else {
//                                self?.showError = true
//                                self?.errorMessage = response.message
//                            }
//                        case .failure(let error):
//                            self?.showError = true
//                            self?.errorMessage = "Failed to add favorite: \(error.localizedDescription)"
//                            print("Error: \(error.localizedDescription)")
//                        }
//                    }
//                }
//            }
//        }

    
    func toggleFavorite(foodId: Int, itemType: String, isCurrentlyFavorite: Bool) {
        if isCurrentlyFavorite {
            removeFavorite(foodId: foodId, itemType: itemType)
        } else {
            createFavoriteFood(foodId: foodId, itemType: itemType)
        }
        getAllFavoriteFood() // Refresh the favorites list
    }
    
    func createFavoriteFood(foodId: Int, itemType: String) {
        FavoriteService.shared.saveFavoriteFood(foodId: foodId, itemType: itemType) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.statusCode == "201" {
                        if itemType == "FOOD_RECIPE" {
                            // Optionally add to favoriteFoodRecipe if needed
                            self?.getAllFavoriteFood() // Refresh the favorites list
                        } else if itemType == "FOOD_SELL" {
                            // Optionally add to favoriteFoodSell if needed
                            self?.getAllFavoriteFood() // Refresh the favorites list
                        }
                        print("Added to favorites successfully.")
                    } else {
                        print("Error adding favorite: \(response.message)")
                    }
                case .failure(let error):
                    print("Failed to add favorite: \(error.localizedDescription)")
                }
            }
        }
    }

}

