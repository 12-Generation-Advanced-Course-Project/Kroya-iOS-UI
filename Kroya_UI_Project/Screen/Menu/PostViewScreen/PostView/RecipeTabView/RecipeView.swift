
import SwiftUI

struct RecipeView: View {
    
    // Properties
    var iselected: Int?
    @StateObject private var viewModel = RecipeViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.recipes) { recipe in
                ZStack {
                    RecipeViewCell(recipe: recipe)
                    
                    NavigationLink(destination: FoodDetailView(
                        theMainImage: "Songvak",
                        subImage1: "ahmok",
                        subImage2: "brohok",
                        subImage3: "SomlorKari",
                        subImage4: "Songvak",
                        showOrderButton: false
                        //showBotton
                    )) {
                        EmptyView()
                    }
                    .opacity(0)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .padding(.vertical, -6)
            }
        }
        .scrollIndicators(.hidden)
        .buttonStyle(PlainButtonStyle())
        .listStyle(.plain)
    }
}

#Preview {
    RecipeView(iselected: 1)
}
