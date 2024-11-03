//
//  AddNewFoodVM.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 31/10/24.
//

import SwiftUI

class AddNewFoodVM: ObservableObject {
    @Published var allNewFoodAndRecipes: [AddNewFoodModel] = []
    @Published var selectedFoodOrRecipe: AddNewFoodModel?

    // MARK: - Add New Recipe/Food
    func addNewRecipeFood(_ newFood: AddNewFoodModel) {
        allNewFoodAndRecipes.append(newFood)
    }

//    // MARK: - Get All Recipes and Foods
//    func getAllRecipeFoods() {
//        // Example static data, can be replaced with API data later
//        let recipe = AddNewFoodModel(
//            photos: ["examplePhoto.jpg"],
//            name: "Classic Pizza",
//            description: "A delicious classic pizza with mozzarella and tomato sauce",
//            durationInMinutes: 30,
//            level: "Easy",
//            cuisineId: 1,
//            categoryId: 2,
//            ingredients: [Ingredient(name: "Mozzarella", quantity: 100, price: 2)],
//            cookingSteps: [CookingStep(description: "Preheat oven to 220°C.")]
//        )
//        allNewFoodAndRecipes.append(recipe)
//        
//        // For Sale Item
//        let foodForSale = AddNewFoodModel(
//            photos: ["examplePhotoForSale.jpg"],
//            name: "Spicy Burger",
//            description: "Juicy burger with spicy sauce",
//            durationInMinutes: 20,
//            level: "Medium",
//            cuisineId: 1,
//            categoryId: 3,
//            ingredients: [Ingredient(name: "Beef Patty", quantity: 1, price: 5)],
//            cookingSteps: [CookingStep(description: "Grill the patty for 5 minutes on each side.")],
//            saleInfo: SaleInfo(dateCooking: "2024-11-03T05:52:32.330Z", amount: 10, price: 8, location: "New York")
//        )
//        allNewFoodAndRecipes.append(foodForSale)
//    }

    // MARK: - Fetch Specific Recipe/Food based on For Sale status
    func fetchRecipeOrFood(forSaleOnly: Bool) -> [AddNewFoodModel] {
        return allNewFoodAndRecipes.filter { $0.isForSale == forSaleOnly }
    }
}
