//
//  CategoryMV.swift
//  Kroya_UI_Project
//
//  Created by kosign on 7/11/24.
//

import Foundation
import Alamofire
import SwiftUI

// MARK: - Category View Model
class CategoryMV: ObservableObject {
    
    @Published var categoryShowModel: [CategoryModel] = []
    @Published var FoodRecipByCategory: [FoodRecipeModel] = []
    @Published var FoodSellByCategory: [FoodSellModel] = []
    @Published var displayCategories: [Category] = []
    
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: - Helper Methods for Loading State
  func startLoading() {
        isLoading = true
    }
    
 func endLoading() {
        isLoading = false
    }
    
    func fetchAllCategory(completion: (() -> Void)? = nil) {
        CategoryService.shared.getAllCategory { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.categoryShowModel = payload
                        self?.displayCategories = self?.mapCategories(payload) ?? []
                        completion?()  // Notify that category data is loaded
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load categories: \(error.localizedDescription)"
                }
            }
        }
    }


    
    // Mapping function to convert API category names to local Category objects
    private func mapCategories(_ categories: [CategoryModel]) -> [Category] {
        categories.compactMap { categoryModel in
            // Capitalize the category name from the API
            let capitalizedCategoryName = categoryModel.categoryName.capitalized

            switch capitalizedCategoryName {
            case "Breakfast":
                return Category(title: .breakfast, image: "khmernoodle", color: Color(hex: "#F2F2F2"), x: 60, y: 18, id: categoryModel.id)
            case "Lunch":
                return Category(title: .lunch, image: "Somlorkoko", color: Color(hex: "#E6F4E8"), x: 60, y: 18, id: categoryModel.id)
            case "Dinner":
                return Category(title: .dinner, image: "DinnerPic", color: .yellow.opacity(0.2), x: 50, y: 14, id: categoryModel.id)
            case "Dessert":
                return Category(title: .dessert, image: "DessertPic", color: .blue.opacity(0.2), x: 50, y: 14, id: categoryModel.id)
            case "Snack":
                return Category(title: .snack, image: "Somlorkoko", color: .pink.opacity(0.2), x: 50, y: 14, id: categoryModel.id)
            default:
                return nil  // Ignore unmatched categories
            }
        }
    }
    // MARK: Get all Category by Id
    func fetchAllCategoryById(categoryId: Int) {
        CategoryService.shared.getAllCategoryById(category: categoryId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        // Directly accessing categoryFoodRecipes and categoryFoodSells
                        self?.FoodRecipByCategory = payload.foodRecipes
                        self?.FoodSellByCategory = payload.foodSells
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load catecory: \(error.localizedDescription)"
                }
            }
        }
    }
}








