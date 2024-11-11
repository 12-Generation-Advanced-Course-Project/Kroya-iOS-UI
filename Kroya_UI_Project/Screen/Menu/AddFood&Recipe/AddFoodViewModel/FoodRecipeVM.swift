//
//  RecipeVM.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 1/11/24.
//

import SwiftUI
import Foundation

class RecipeViewModel: ObservableObject {
    
    @Published var RecipeFood: [FoodRecipeModel] = []
    @Published var RecipeByCategory: [FoodRecipeModel] = []
    @Published var RecipeCuisine: [CuisinesModel] = []
    
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: Helper functions for loading state
    private func startLoading() {
        isLoading = true
    }
    
    private func endLoading() {
        isLoading = false
    }

    // MARK: Get All Recipe Food
    func getAllRecipeFood() {
        startLoading()
        FoodRecipeService.shared.getFoodRecipe { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.RecipeFood = payload
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

    // MARK: Get Recipes by Category
    func getRecipesByCuisine(cuisineId: Int) {
        startLoading()
        FoodRecipeService.shared.getAllFoodRecipeByCategory(category: cuisineId) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
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

    // MARK: Search Food Recipe by Name
    func getSearchFoodRecipeByName(searchText: String) {
        startLoading()
        FoodRecipeService.shared.getSearchFoodRecipeByName(searchText: searchText) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.RecipeByCategory = payload
                        self?.getAllRecipeFood()
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

    // MARK: Create a New Recipe
    func createFoodRecipe(from foodRecipeRequest: FoodRecipeRequest) {
        startLoading()
        FoodRecipeService.shared.saveFoodRecipe(foodRecipeRequest) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if let createdRecipeId = response.payload?.first {
                        self?.successMessage = "Recipe created successfully with ID: \(createdRecipeId)"
                        self?.getAllRecipeFood()
                    } else {
                        self?.successMessage = "Recipe created successfully"
                    }
                    self?.showError = false
                case .failure(let error):
                    self?.errorMessage = "Failed to create recipe: \(error.localizedDescription)"
                    self?.showError = true
                }
            }
        }
    }
    
    
    
    // MARK: Get All Cuisines
       func getAllCuisines() {
           self.isLoading = true
           FoodRecipeService.shared.getAllCuisines { [weak self] result in
               DispatchQueue.main.async {
                   self?.isLoading = false
                   switch result {
                   case .success(let response):
                       if response.statusCode == "200", let payload = response.payload {
                           self?.RecipeCuisine = payload // Assign fetched cuisines
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
