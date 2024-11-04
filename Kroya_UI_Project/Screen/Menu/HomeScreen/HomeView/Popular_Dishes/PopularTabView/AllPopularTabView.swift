import SwiftUI

struct AllPopularTabView: View {
    
    @StateObject private var foodOnSaleViewModel = FoodOnSaleViewCellViewModel()
    @StateObject private var addNewFoodVM = AddNewFoodVM()
    
    var isSelected: Int?
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                // Food on Sale Cards (Limited to 3)
                ForEach(foodOnSaleViewModel.foodOnSaleItems.prefix(3)) { foodSale in
                    NavigationLink(destination:
                                    FoodDetailView(
                                        theMainImage: foodSale.imageName,
                                        subImage1: "ahmok",
                                        subImage2: "brohok",
                                        subImage3: "SomlorKari",
                                        subImage4: foodSale.imageName,
                                        showPrice: true
                                    )
                    ) {
                        FoodOnSaleViewCell(foodSale: foodSale)
                            .frame(width: 362)
                            .padding(.top, 8)
                    }
                }
                
                // Recipe/Food Cards (from AddNewFoodVM)
                ForEach(addNewFoodVM.allNewFoodAndRecipes) { recipe in
                    NavigationLink(destination:
                                    FoodDetailView(
                                        theMainImage: recipe.photos.first?.photo ?? "defaultImage",
                                        subImage1: recipe.photos.dropFirst().first?.photo ?? "defaultImage",
                                        subImage2: recipe.photos.dropFirst(2).first?.photo ?? "defaultImage",
                                        subImage3: recipe.photos.dropFirst(3).first?.photo ?? "defaultImage",
                                        subImage4: recipe.photos.dropFirst(4).first?.photo ?? "defaultImage",
                                        showOrderButton: recipe.isForSale
                                    )
                    ) {
                        RecipeViewCell(recipe: recipe)
                            .frame(width: 362)
                            .padding(.top, 8)
                    }
                }
            }
        }
        .environmentObject(foodOnSaleViewModel)
        .environmentObject(addNewFoodVM)
    }
}

#Preview {
    AllPopularTabView()
        .environmentObject(FoodOnSaleViewCellViewModel()) // Injecting sample environment objects for preview
        .environmentObject(AddNewFoodVM())
}
