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
    
    // MARK: - Helper Methods for Loading State
    private func startLoading() {
        isLoading = true
    }
    
    private func endLoading() {
        isLoading = false
    }
    
    func fetchAllCategory() {
        CategoryService.shared.getAllCategory { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.categoryShowModel = payload
                        self?.displayCategories = self?.mapCategories(payload) ?? []
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
    private func mapCategories(_ categories: [CategoryModel]) -> [Category] {
        categories.compactMap { categoryModel in
            switch categoryModel.categoryName.lowercased() {
            case "breakfast":
                return Category(title: .breakfast, image: "khmernoodle", color: Color(hex: "#F2F2F2"), x: 60, y: 18, id: categoryModel.id)
            case "lunch":
                return Category(title: .lunch, image: "Somlorkoko", color: Color(hex: "#E6F4E8"), x: 60, y: 18, id: categoryModel.id)
            case "dinner":
                return Category(title: .dinner, image: "DinnerPic", color: .yellow.opacity(0.2), x: 50, y: 14, id: categoryModel.id)
            case "dessert":
                return Category(title: .dessert, image: "DessertPic", color: .blue.opacity(0.2), x: 50, y: 14, id: categoryModel.id)
            case "snack":
                return Category(title: .snack, image: "khmernoodle", color: .pink.opacity(0.2), x: 50, y: 14, id: categoryModel.id)
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
                        print("Error fetching categories by ID: \(response.message)")
                    }
                case .failure(let error):
                    print("Request failed with error: \(error.localizedDescription)")
                }
            }
        }
    }
}








