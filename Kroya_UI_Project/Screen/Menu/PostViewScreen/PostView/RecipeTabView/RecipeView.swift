import SwiftUI

struct RecipeView: View {
    var iselected: Int?
    @EnvironmentObject var viewModel: AddNewFoodVM
    
    var body: some View {
        VStack {
            if viewModel.allNewFoodAndRecipes.isEmpty {
                Text("No Recipes Found")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(viewModel.allNewFoodAndRecipes.filter { !$0.isForSale }) { recipe in
                        ZStack {
                            RecipeViewCell(recipe: recipe)
                                .padding(.vertical, 6)
                            
                            NavigationLink(destination:  FoodDetailView(
                                theMainImage:"Hotpot",
                                subImage1:  "Chinese Hotpot",
                                subImage2:  "Chinese",
                                subImage3:  "Fly-By-Jing",
                                subImage4:  "Mixue",
                                showOrderButton: false
                            )) {
                                EmptyView()
                            }
                            .opacity(0)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if viewModel.allNewFoodAndRecipes.isEmpty {
                print("Using static recipes:", viewModel.allNewFoodAndRecipes)
            }
        }
    }
}
