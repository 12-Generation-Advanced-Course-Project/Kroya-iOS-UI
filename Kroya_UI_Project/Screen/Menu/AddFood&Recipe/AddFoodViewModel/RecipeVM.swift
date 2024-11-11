//
//  RecipeVM.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 1/11/24.
//

import SwiftUI
import Foundation

class RecipeViewModel: ObservableObject {
    
    @Published var RecipeFood: [RecipeModel] = []
    @Published var RecipeByCategory: [RecipeModel] = []
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    //MARK: Get Recipe Food
    func getAllRecipeFood() {
        self.isLoading = true
        FoodRecipeService.shared.getFoodRecipe{ [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        if let payload = response.payload {
                            self?.RecipeFood = payload
                        }
                        self?.successMessage = "Recipe food fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load profile: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
    
    
    
    //MARK: Get all Recipe By Category
    func getRecipesByCuisine(cuisineId: Int) {
        self.isLoading = true
        FoodRecipeService.shared.getAllFoodRecipeByCategory(category: cuisineId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.RecipeByCategory = payload
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

    
    
    //MARK: Get Search Food Recipe By Name
    func getSearchFoodRecipeByName(searchText: String) {
        self.isLoading = true
        FoodRecipeService.shared.getSearchFoodRecipeByName(searchText: searchText) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.RecipeByCategory = payload // Storing search results here
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

    
    
    
    
}
