import SwiftUI

struct AllPopularTabView: View {
    
    @StateObject private var foodOnSaleViewModel = FoodOnSaleViewCellViewModel()
    @StateObject private var addNewFoodVM = AddNewFoodVM()
    @StateObject private var recipeViewModel = RecipeViewModel()
    var isSelected: Int?
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ForEach(addNewFoodVM.allNewFoodAndRecipes.filter { $0.isForSale }.prefix(3)) { foodSale in
                    NavigationLink(destination:
                                    FoodDetailView(
                                       theMainImage:"Hotpot",
                                       subImage1:  "Chinese Hotpot",
                                       subImage2:  "Chinese",
                                       subImage3:  "Fly-By-Jing",
                                       subImage4:  "Mixue",
                                       showOrderButton: true,
                                       showPrice: foodSale.isForSale
                                   )
                    ) {
                        FoodOnSaleViewCell(foodSale: foodSale)
                            .frame(width: 362)
                            .padding(.top, 8)
                    }
                }
                ForEach(recipeViewModel.RecipeFood) { recipe in
                    NavigationLink(destination:
                                    FoodDetailView(
                                       theMainImage:"Hotpot",
                                       subImage1:  "Chinese Hotpot",
                                       subImage2:  "Chinese",
                                       subImage3:  "Fly-By-Jing",
                                       subImage4:  "Mixue",
                                       showOrderButton: true
                               
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
