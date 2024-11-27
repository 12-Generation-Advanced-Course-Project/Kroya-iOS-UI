

import SwiftUI

struct FoodonRecipe: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var recipeViewModel = RecipeViewModel()
    @StateObject private var guestFoodRecipeVM = GuestFoodRecipeVM()
    @StateObject private var favoriteFoodRecipe = FavoriteVM()
    let imageofOrder: [String] = ["SoupPic", "SaladPic", "GrillPic", "DessertPic 1"]
    let titleofOrder: [String] = ["Soup", "Salad", "Grill", "Dessert"]
    @State private var selectedOrderIndex: Int? = nil
    let cuisineImages: [String: String] = [
        "Soup": "SoupPic",
        "Salad": "SaladPic",
        "Grill": "GrillPic",
        "Dessert": "DessertPic 1"
    ]
    @StateObject private var keyboardResponder = KeyboardResponder()
    @State var isChooseCuisine = false
    var body: some View {
        NavigationView {
            ScrollView(.vertical,showsIndicators: false){
                VStack {
                    // Cuisine Selection Buttons
                    CuisineCategoryButtons(
                        imageofOrder: imageofOrder,
                        titleofOrder: titleofOrder,
                        selectedOrderIndex: $selectedOrderIndex,
                        isChooseCuisine: $isChooseCuisine,
                        recipeFoodVM: recipeViewModel,
                        guestFoodRecipeVM: guestFoodRecipeVM)
                    
                    HStack(spacing: 40) {
                        ForEach(recipeViewModel.RecipeCuisine) { cuisine in
                            Button(action: {
                                if Auth.shared.hasAccessToken(){
                                    if selectedOrderIndex == cuisine.id {
                                        recipeViewModel.getAllRecipeFood()
                                        isChooseCuisine = false
                                        selectedOrderIndex = nil
                                    } else {
                                        selectedOrderIndex = cuisine.id
                                        recipeViewModel.getRecipesByCuisine(cuisineId: cuisine.id)
                                        isChooseCuisine = true
                                    }
                                }else {
                                    if selectedOrderIndex == cuisine.id {
                                        guestFoodRecipeVM.getAllGuestRecipeFood()
                                        isChooseCuisine = false
                                        selectedOrderIndex = nil
                                    } else {
                                        selectedOrderIndex = cuisine.id
                                        guestFoodRecipeVM.getRecipesByCuisine(cuisineId: cuisine.id)
                                        isChooseCuisine = true
                                    }
                                }
                            }) {
    //                            VStack {
    //                                let imageName = cuisineImages[cuisine.cuisineName] ?? "snackPic"
    //                                Image(imageName)
    //                                    .resizable()
    //                                    .scaledToFill()
    //                                    .frame(width: 60, height: 60)
    //                                    .cornerRadius(12)
    //
    //                                Text(cuisine.cuisineName)
    //                                    .font(.customfont(.medium, fontSize: 16))
    //                                    .foregroundColor(selectedOrderIndex == cuisine.id && recipeViewModel.isChooseCuisine ? Color.yellow : Color.gray)
    //                            }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer().frame(height: 20)
                    
                    Text("All")
                        .font(.customfont(.bold, fontSize: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black.opacity(0.8))
                        .padding(.horizontal)
                    if Auth.shared.hasAccessToken(){
                        if recipeViewModel.isLoading {
                            ZStack {
                                Color.white
                                    .edgesIgnoringSafeArea(.all)
                                
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                                    .scaleEffect(2)
                                    .offset(y: 180)
                            }
                        } else {
                            ScrollView {
                                LazyVStack {
                                    ForEach(isChooseCuisine ? recipeViewModel.RecipeByCategory : recipeViewModel.filteredFoodRecipeList) { recipe in
                                        NavigationLink(destination:
                                                        FoodDetailView(
                                                        isFavorite: recipe.isFavorite ?? false,
                                                        showPrice: false, // Always false for recipes
                                                        showOrderButton: false, // Always false for recipes
                                                        showButtonInvoic: nil, // Not applicable
                                                        invoiceAccept: nil, // Not applicable
                                                        FoodId: recipe.id,
                                                        ItemType: recipe.itemType
                                                    )
                                        ) {
                                            RecipeViewCell(
                                                recipe: recipe,
                                                foodId: recipe.id,
                                                itemType: "FOOD_RECIPE",
                                                isFavorite: recipe.isFavorite ?? false // Use the value from `recipe.isFavorite`
                                            )
                                            .frame(maxWidth: .infinity)
                                            .padding(.horizontal, 20)
                                        }
                                    }
                                }
                            }

                        }
                    } else {
                        if guestFoodRecipeVM.isLoading {
                            ZStack {
                                Color.white
                                    .edgesIgnoringSafeArea(.all)
                                
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                                    .scaleEffect(2)
                                    .offset(y: 180)
                            }
                        } else {
                            ScrollView {
                                LazyVStack {
                                    ForEach(isChooseCuisine ? guestFoodRecipeVM.GuestFoodRecipeByCuisine : guestFoodRecipeVM.filteredFoodRecipeList) { guestRecipe in
                                        NavigationLink(destination:
                                                        FoodDetailView(
                                                        isFavorite: guestRecipe.isFavorite ?? false,
                                                        showPrice: false, // Always false for recipes
                                                        showOrderButton: false, // Always false for recipes
                                                        showButtonInvoic: nil, // Not applicable
                                                        invoiceAccept: nil, // Not applicable
                                                        FoodId: guestRecipe.id,
                                                        ItemType: guestRecipe.itemType
                                                    )
                                        ) {
                                            RecipeViewCell(
                                                recipe: guestRecipe,
                                                foodId: guestRecipe.id,
                                                itemType: "FOOD_RECIPE",
                                                isFavorite: guestRecipe.isFavorite ?? false // Use the value from `recipe.isFavorite`
                                            )
                                            .frame(maxWidth: .infinity)
                                            .padding(.horizontal, 20)
                                        }
                                    }
                                }
                            }

                        }
                    }
                    Spacer()
                }
                .navigationTitle("Food Recipe")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .simultaneousGesture(
                TapGesture().onEnded {
                    hideKeyboard()
                }
            )
            .padding(.bottom, min(keyboardResponder.currentHeight, 0))
        }
        .onAppear {
            recipeViewModel.getAllCuisines()
            recipeViewModel.getAllRecipeFood()
            guestFoodRecipeVM.getAllGuestCuisines()
            guestFoodRecipeVM.getAllGuestRecipeFood()
            
        }
        
        .searchable(text: $recipeViewModel.searchText, prompt: LocalizedStringKey("Search Item"))
        .navigationBarBackButtonHidden(true)
    }
    
    // Separate view for Cuisine Category Buttons
    struct CuisineCategoryButtons: View {
        let imageofOrder: [String]
        let titleofOrder: [String]
        @Binding var selectedOrderIndex: Int?
        @Binding var isChooseCuisine: Bool
        @ObservedObject var recipeFoodVM: RecipeViewModel
        @ObservedObject var guestFoodRecipeVM: GuestFoodRecipeVM
        
        var body: some View {
            HStack(spacing: 40) {
                ForEach(0..<imageofOrder.count, id: \.self) { index in
                    Button(action: {
                        if Auth.shared.hasAccessToken(){
                            if selectedOrderIndex == index {
                                recipeFoodVM.getAllRecipeFood()
                                isChooseCuisine = false
                            } else {
                                selectedOrderIndex = index
                                recipeFoodVM.getRecipesByCuisine(cuisineId: index + 1)
                                isChooseCuisine = true
                            }
                        } else {
                            if selectedOrderIndex == index {
                                guestFoodRecipeVM.getAllGuestRecipeFood()
                                isChooseCuisine = false
                            } else {
                                selectedOrderIndex = index
                                guestFoodRecipeVM.getRecipesByCuisine(cuisineId: index + 1)
                                isChooseCuisine = true
                            }
                        }
                    }) {
                        VStack {
                            Image(imageofOrder[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                            
                            Text(titleofOrder[index])
                                .font(.customfont(.medium, fontSize: 16))
                                .foregroundColor(selectedOrderIndex == index && isChooseCuisine ? Color.yellow : Color.gray)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
