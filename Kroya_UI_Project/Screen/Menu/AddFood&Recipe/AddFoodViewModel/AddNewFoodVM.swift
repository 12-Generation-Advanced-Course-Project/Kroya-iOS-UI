//
//  AddNewFoodVM.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 31/10/24.
//

import SwiftUI

class AddNewFoodVM: ObservableObject {
    @Published var allNewFoodAndRecipes: [AddNewFoodModel] = [
        // Food Sale Item 1 - McDonald's Big Mac
        AddNewFoodModel(
            photos: [Photo(photo: "bigmac.jpg")],
            name: "Big Mac Soup",
            description: "The iconic McDonald's Big Mac with two beef patties, lettuce, cheese, pickles, and special sauce.",
            durationInMinutes: 5,
            level: "Easy",
            cuisineId: 1, // Fast Food
            categoryId: 1, // Snack
            ingredients: [
                RecipeIngredient(id: 1, name: "Beef Patty", quantity: 2, price: 3.0, selectedCurrency: 1),
                RecipeIngredient(id: 2, name: "Lettuce", quantity: 20, price: 0.5, selectedCurrency: 1),
                RecipeIngredient(id: 3, name: "Cheese Slice", quantity: 1, price: 1.0, selectedCurrency: 1),
                RecipeIngredient(id: 4, name: "Pickles", quantity: 10, price: 0.3, selectedCurrency: 1),
                RecipeIngredient(id: 5, name: "Big Mac Sauce", quantity: 15, price: 0.7, selectedCurrency: 1)
            ],
            cookingSteps: [
                CookingStep(id: 1, description: "Toast the bun."),
                CookingStep(id: 2, description: "Cook the beef patties until done."),
                CookingStep(id: 3, description: "Assemble with lettuce, cheese, pickles, and sauce.")
            ],
            saleIngredients: SaleIngredient(
                cookDate: "2024-11-01",
                amount: 5,
                price: 6.99,
                location: "McDonald's, New York",
                selectedCurrency: 1
            ),
            rating: 4.5,
            reviewCount: 1200
        ),
        
        // Food Sale Item 2 - McDonald's French Fries
//        AddNewFoodModel(
//            photos: [Photo(photo: "frenchfries.jpg")],
//            name: "Khmer Beef Salad",
//            description: "Crispy golden fries, salted to perfection - a McDonald's classic.",
//            durationInMinutes: 3,
//            level: "Easy",
//            cuisineId: 2, // Fast Food
//            categoryId: 1, // Snack
//            ingredients: [
//                RecipeIngredient(id: 6, name: "Potatoes", quantity: 200, price: 1.0, selectedCurrency: 1),
//                RecipeIngredient(id: 7, name: "Salt", quantity: 5, price: 0.1, selectedCurrency: 1),
//                RecipeIngredient(id: 8, name: "Vegetable Oil", quantity: 30, price: 0.5, selectedCurrency: 1)
//            ],
//            cookingSteps: [
//                CookingStep(id: 4, description: "Cut the potatoes into fries."),
//                CookingStep(id: 5, description: "Fry the potatoes until golden and crispy."),
//                CookingStep(id: 6, description: "Sprinkle with salt and serve.")
//            ],
//            saleIngredients: SaleIngredient(
//                cookDate: "2024-11-02",
//                amount: 10,
//                price: 2.99,
//                location: "McDonald's, Los Angeles",
//                selectedCurrency: 1
//            ),
//            rating: 4.3,
//            reviewCount: 2500
//        ),
        // Food Sale Item 3 - McDonald's French Fries
        AddNewFoodModel(
            photos: [Photo(photo: "frenchfries.jpg")],
            name: "Khmer Grill Steak",
            description: "Crispy golden fries, salted to perfection - a McDonald's classic.",
            durationInMinutes: 3,
            level: "Easy",
            cuisineId: 3, // Fast Food
            categoryId: 1, // Snack
            ingredients: [
                RecipeIngredient(id: 6, name: "Potatoes", quantity: 200, price: 1.0, selectedCurrency: 1),
                RecipeIngredient(id: 7, name: "Salt", quantity: 5, price: 0.1, selectedCurrency: 1),
                RecipeIngredient(id: 8, name: "Vegetable Oil", quantity: 30, price: 0.5, selectedCurrency: 1)
            ],
            cookingSteps: [
                CookingStep(id: 4, description: "Cut the potatoes into fries."),
                CookingStep(id: 5, description: "Fry the potatoes until golden and crispy."),
                CookingStep(id: 6, description: "Sprinkle with salt and serve.")
            ],
            saleIngredients: SaleIngredient(
                cookDate: "2024-11-02",
                amount: 10,
                price: 3.79,
                location: "McDonald's, Los Angeles",
                selectedCurrency: 1
            ),
            rating: 2.7,
            reviewCount: 1500
        ),
        // Food Sale Item 4 - McDonald's French Fries
//        AddNewFoodModel(
//            photos: [Photo(photo: "frenchfries.jpg")],
//            name: "Nom Tnout",
//            description: "Crispy golden fries, salted to perfection - a McDonald's classic.",
//            durationInMinutes: 4,
//            level: "Easy",
//            cuisineId: 4, // Fast Food
//            categoryId: 1, // Snack
//            ingredients: [
//                RecipeIngredient(id: 6, name: "Potatoes", quantity: 200, price: 1.0, selectedCurrency: 1),
//                RecipeIngredient(id: 7, name: "Salt", quantity: 5, price: 0.1, selectedCurrency: 1),
//                RecipeIngredient(id: 8, name: "Vegetable Oil", quantity: 30, price: 0.5, selectedCurrency: 1)
//            ],
//            cookingSteps: [
//                CookingStep(id: 4, description: "Cut the potatoes into fries."),
//                CookingStep(id: 5, description: "Fry the potatoes until golden and crispy."),
//                CookingStep(id: 6, description: "Sprinkle with salt and serve.")
//            ],
//            saleIngredients: SaleIngredient(
//                cookDate: "2024-11-01",
//                amount: 10,
//                price: 3.29,
//                location: "McDonald's, Los Angeles",
//                selectedCurrency: 1
//            ),
//            rating: 4.2,
//            reviewCount: 3500
//        ),
        
    // Recipe Item 1 - Kung Pao Chicken
        AddNewFoodModel(
            photos: [Photo(photo: "kungpaochicken.jpg")],
            name: "Kung Pao Chicken",
            description: "A spicy, stir-fried Chinese dish made with chicken, peanuts, and vegetables.",
            durationInMinutes: 30,
            level: "Medium",
            cuisineId: 2, // Chinese Cuisine
            categoryId: 2, // Dinner
            ingredients: [
                RecipeIngredient(id: 9, name: "Chicken Breast", quantity: 200, price: 3.5, selectedCurrency: 1),
                RecipeIngredient(id: 10, name: "Peanuts", quantity: 50, price: 1.0, selectedCurrency: 1),
                RecipeIngredient(id: 11, name: "Bell Peppers", quantity: 100, price: 0.8, selectedCurrency: 1),
                RecipeIngredient(id: 12, name: "Soy Sauce", quantity: 20, price: 0.2, selectedCurrency: 1),
                RecipeIngredient(id: 13, name: "Chili Peppers", quantity: 10, price: 0.3, selectedCurrency: 1)
            ],
            cookingSteps: [
                CookingStep(id: 7, description: "Marinate the chicken with soy sauce and chili."),
                CookingStep(id: 8, description: "Stir-fry the chicken until golden."),
                CookingStep(id: 9, description: "Add vegetables and peanuts, stir until cooked.")
            ],
            saleIngredients: nil,
            rating: 4.6,
            reviewCount: 800
        ),
        
        // Recipe Item 2 - Sweet and Sour Pork
        AddNewFoodModel(
            photos: [Photo(photo: "sweetandsourpork.jpg")],
            name: "Sweet and Sour Pork",
            description: "A classic Chinese dish with crispy pork in a sweet and tangy sauce.",
            durationInMinutes: 40,
            level: "Hard",
            cuisineId: 2, // Chinese Cuisine
            categoryId: 2, // Dinner
            ingredients: [
                RecipeIngredient(id: 14, name: "Pork Belly", quantity: 300, price: 4.0, selectedCurrency: 1),
                RecipeIngredient(id: 15, name: "Pineapple Chunks", quantity: 50, price: 1.0, selectedCurrency: 1),
                RecipeIngredient(id: 16, name: "Bell Peppers", quantity: 100, price: 0.8, selectedCurrency: 1),
                RecipeIngredient(id: 17, name: "Vinegar", quantity: 20, price: 0.2, selectedCurrency: 1),
                RecipeIngredient(id: 18, name: "Sugar", quantity: 20, price: 0.1, selectedCurrency: 1)
            ],
            cookingSteps: [
                CookingStep(id: 10, description: "Coat the pork with flour and fry until crispy."),
                CookingStep(id: 11, description: "Prepare sweet and sour sauce with vinegar and sugar."),
                CookingStep(id: 12, description: "Add pork, pineapple, and bell peppers to the sauce.")
            ],
            saleIngredients: nil,
            rating: 4.8,
            reviewCount: 950
        )
    ]


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
