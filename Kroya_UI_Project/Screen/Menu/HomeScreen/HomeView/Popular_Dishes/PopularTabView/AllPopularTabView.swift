import SwiftUI

struct AllPopularTabView: View {
    var isSelected: Int?
    var popularFood: [PopularFoodVM]
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                FoodOnSaleView()
                RecipeView()
            }
        }}}

