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
    
    // MARK: - Add New Recipe/Food from Draft
    func addNewRecipeFood(from draftData: DraftModelData) {
        let cuisineId = cuisine(rawValue: draftData.selectedCuisine ?? "")?.id ?? 0
        let categoryId = category(rawValue: draftData.selectedCategory ?? "")?.id ?? 0
        let newFood = AddNewFoodModel(
            photos: draftData.selectedImages.map { image in
                Photo(photo: "\(UUID().uuidString).jpg")
            },
            name: draftData.foodName,
            description: draftData.descriptionText,
            durationInMinutes: Int(draftData.duration),
            level: draftData.selectedLevel ?? "",
            cuisineId:cuisineId,
            categoryId: categoryId,
            ingredients: draftData.ingredients,
            cookingSteps: draftData.cookingSteps,
            saleIngredients: draftData.isForSale ? SaleIngredient(
                cookDate: draftData.cookDate.description,
                amount: draftData.amount,
                price: draftData.price,
                location: draftData.location,
                selectedCurrency: 0
            ) : nil
        )
        
        // Add new food or recipe to the list
        allNewFoodAndRecipes.append(newFood)
        print("Added new recipe:", newFood)
        print("Current recipes after adding:", allNewFoodAndRecipes)
        objectWillChange.send()
        // Print the data to verify it's being saved correctly
        print("New Recipe/Food added from draft:")
        print("Name: \(newFood.name)")
        print("Description: \(newFood.description)")
        print("Duration: \(newFood.durationInMinutes) minutes")
        print("Level: \(newFood.level)")
        print("Cuisine ID: \(newFood.cuisineId)")
        print("Category ID: \(newFood.categoryId)")
        print("Ingredients:")
        for ingredient in newFood.ingredients {
            print("  - Name: \(ingredient.name), Quantity: \(ingredient.quantity), Price: \(ingredient.price), Currency: \(ingredient.selectedCurrency)")
        }
        print("Cooking Steps:")
        for step in newFood.cookingSteps {
            print("  - Step: \(step.description)")
        }
        
        if let saleInfo = newFood.saleIngredients {
            print("Sale Information:")
            print("  - Cook Date: \(saleInfo.cookDate)")
            print("  - Amount: \(saleInfo.amount)")
            print("  - Price: \(saleInfo.price)")
            print("  - Location: \(saleInfo.location)")
            print("  - Selected Currency: \(saleInfo.selectedCurrency)")
        } else {
            print("This item is not for sale.")
        }
        print("Images:")
        for (index, image) in draftData.selectedImages.enumerated() {
            let imageName = "\(UUID().uuidString).jpg"
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                print("  - Image \(index + 1): name = \(imageName), size = \(imageData.count) bytes")
            }
        }
        print("All recipes after posting:", allNewFoodAndRecipes)
    }

    
    // MARK: - Fetch Specific Recipe/Food based on For Sale status
    func fetchRecipeOrFood(forSaleOnly: Bool) {
        allNewFoodAndRecipes = allNewFoodAndRecipes.filter { $0.isForSale == forSaleOnly }
        print("Fetched recipes for sale only (\(forSaleOnly)): \(allNewFoodAndRecipes)")
    }

}
