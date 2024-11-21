//
//  GuestCategoryVM.swift
//  Kroya_UI_Project
//
//  Created by kosign on 21/11/24.
//

import Foundation
import Alamofire
import SwiftUI

class GuestCategoryVM: ObservableObject{
    
    @Published var guestCategoryModel: [CategoryModel] = []
    @Published var guestFoodRecipByCategory: [FoodRecipeModel] = []
    @Published var guestFoodSellByCategory: [FoodSellModel] = []
    @Published var displayGuestCategories: [Category] = []

    
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    
    // MARK: - Helper Methods for Loading State
    private func startLoading() {
        isLoading = true
    }
    
    private func endLoading() {
        isLoading = false
    }
    
    func fetchAllGuestCategory() {
        GuestCategoryService.shared.getAllGuestCategories { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.guestCategoryModel = payload
                        self?.displayGuestCategories = self?.mapGuestCategories(payload) ?? []
                    } else {
                        print("Error fetching categories: \(response.message)")
                    }
                case .failure(let error):
                    print("Request failed with error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Mapping function to convert API category names to local Category objects
    private func mapGuestCategories(_ categories: [CategoryModel]) -> [Category] {
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
    
    // MARK: Get all Guest Category by Id
    func fetchAllfoodByCategoryId(categoryId: Int) {
        GuestCategoryService.shared.getAllGuestFoodCategoryById(category: categoryId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        // Directly accessing categoryFoodRecipes and categoryFoodSells
                        self?.guestFoodRecipByCategory = payload.foodRecipes
                        self?.guestFoodSellByCategory = payload.foodSells
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
