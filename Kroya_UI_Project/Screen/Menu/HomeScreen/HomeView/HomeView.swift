import SwiftUI

struct Category {
    let title: FoodCategory
    let image: String
    let color: Color
    let x: CGFloat
    let y: CGFloat
}

enum FoodCategory: String {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case dessert = "Dessert"
}

struct HomeView: View {
    
    @EnvironmentObject var addNewFoodVM: AddNewFoodVM
    let notification = [1, 2, 3, 4, 5]
    @StateObject private var recipeViewModel = RecipeViewModel()
    @StateObject private var categoryvm = CategoryMV()
    @State var isSearching: Bool = false
    @Environment(\.locale) var locale
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) { // Added spacing between sections
                    // Title Section
                    VStack(alignment: .leading, spacing: 8) { // Added spacing between text elements
                        Text(LocalizedStringKey("What would you like to eat today ?"))
                            .frame(width: locale.identifier == "ko" ? 170 : locale.identifier == "km-KH" ? 120 : 250)
                            .customFontSemiBoldLocalize(size: 23)
                            .padding(.horizontal, 10)
                        
                        // Recipe Order Cards
                        HStack(spacing: 16) {
                            NavigationLink(destination: FoodonOrderView()) {
                                Recipe_OrderCard(
                                    title: LocalizedStringKey("Food order"),
                                    subtitle: LocalizedStringKey("Order what you love"),
                                    imageName: "food_recipe",
                                    width: .screenWidth * 0.45,
                                    height: .screenHeight * 0.16,
                                    heightImage: 90,
                                    widthImage: 120,
                                    xImage: 28,
                                    yImage: 35
                                )
                            }
                            
                            NavigationLink(destination: FoodonRecipe()) {
                                Recipe_OrderCard(
                                    title: LocalizedStringKey("Food Recipe"),
                                    subtitle: LocalizedStringKey("Learn how to cook"),
                                    imageName: "Menu",
                                    width: .screenWidth * 0.45,
                                    height: .screenHeight * 0.16,
                                    heightImage: 60,
                                    widthImage: 85,
                                    xImage: 40,
                                    yImage: 33
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Category Section
                    VStack(alignment: .leading, spacing: 8) { // Added spacing between elements
                        Text(LocalizedStringKey("Category"))
                            .customFontSemiBoldLocalize(size: 16)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) { // Added spacing between category cards
                                ForEach(categoryvm.displayCategories, id: \.title) { category in
                                    NavigationLink(destination: destinationView(for: category.title)) {
                                        CategoryCardView(
                                            title: LocalizedStringKey(category.title.rawValue),
                                            image: category.image,
                                            color: category.color,
                                            x: category.x,
                                            y: category.y
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Popular Dishes Section
                    HStack {
                        Text(LocalizedStringKey("Popular Dishes"))
                            .customFontSemiBoldLocalize(size: 16)
                        Spacer()
                        NavigationLink {
                            ViewAllPopularDishesView()
                        } label: {
                            HStack(spacing: 10){
                                Text(LocalizedStringKey("View all"))
                                    .foregroundStyle(PrimaryColor.normal)
                                    .customFontSemiBoldLocalize(size: 16)
                                Image(systemName: "arrow.right")
                                    .foregroundStyle(PrimaryColor.normal)
                                    .offset(y: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Scrollable Dishes
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) { // Added spacing between food cards
                            // Food on Sale Cards (Limited to 2)
                            ForEach(addNewFoodVM.allNewFoodAndRecipes) { foodSale in
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
                                        .frame(width: 360)
                                }
                            }
                            
                            // Recipe/Food Cards from AddNewFoodVM (Limited to 2)
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
                                        .frame(width: 360)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 16) // Added padding to top
                .navigationTitle("")
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image("KroyaYellowLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 73, height: 73)
                            .offset(x: -10)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SearchScreen()) {
                            Image("ico_search")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.black)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: Notification()) {
                            ZStack {
                                Image("notification")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.black)
                                
                                // Notification Badge
                                if notification.count > 0 {
                                    Text("\(notification.count)")
                                        .font(.customfont(.semibold, fontSize: 12))
                                        .foregroundColor(.white)
                                        .padding(5)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 1)
                                        )
                                        .offset(x: 10, y: -10)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                categoryvm.fetchAllCategory()
            }
        }
    }
    
    @ViewBuilder
    func destinationView(for title: FoodCategory) -> some View {
        switch title {
        case .breakfast:
            BreakfastScreenView()
        case .lunch:
            LunchScreenView()
        case .dinner:
            DinnerScreenView()
        case .dessert:
            DessertScreenView()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AddNewFoodVM())
}
