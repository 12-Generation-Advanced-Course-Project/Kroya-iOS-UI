import SwiftUI

struct AllPopularTabView: View {
    
    @StateObject private var foodOnSaleViewModel = FoodOnSaleViewCellViewModel()
    @StateObject private var addNewFoodVM = AddNewFoodVM()
    
    var isSelected: Int?
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                // Food on Sale Cards (Limited to 3)
                ForEach(addNewFoodVM.allNewFoodAndRecipes.prefix(3)) { foodSale in
                    NavigationLink(destination:
                                    FoodDetailView(
                                       theMainImage:"Hotpot",
                                       subImage1:  "Chinese Hotpot",
                                       subImage2:  "Chinese",
                                       subImage3:  "Fly-By-Jing",
                                       subImage4:  "Mixue",
                                       showOrderButton: foodSale.isForSale
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
                                       theMainImage:"Hotpot",
                                       subImage1:  "Chinese Hotpot",
                                       subImage2:  "Chinese",
                                       subImage3:  "Fly-By-Jing",
                                       subImage4:  "Mixue",
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
