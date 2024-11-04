import SwiftUI

struct Category {
    let title: String
    let image: String
    let color: Color
    let x: CGFloat
    let y: CGFloat
}

struct HomeView: View {
    
    @StateObject private var foodOnSaleViewModel = FoodOnSaleViewCellViewModel()
    @EnvironmentObject var addNewFoodVM: AddNewFoodVM // Use @EnvironmentObject instead of @StateObject
    let notification = [1, 2, 3, 4, 5]
    
    let categories: [Category] = [
        Category(title: "Breakfast", image: "khmernoodle", color: Color(hex: "#F2F2F2"), x: 60, y: 18),
        Category(title: "Lunch", image: "Somlorkoko", color: Color(hex: "#E6F4E8"), x: 60, y: 18),
        Category(title: "Dinner", image: "DinnerPic", color: .yellow.opacity(0.2), x: 50, y: 14),
        Category(title: "Dessert", image: "DessertPic", color: .blue.opacity(0.2), x: 50, y: 14)
    ]

    @State var isSearching: Bool = false
    @Environment(\.locale) var locale

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    // Title Section
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey("What would you like to eat today ?"))
                            .frame(width: locale.identifier == "ko" ? 170 : locale.identifier == "km-KH" ? 120 : 250)
                            .customFontSemiBoldLocalize(size: 23)

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
                    }

                    Spacer().frame(height: 25)

                    // Category Section
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey("Category"))
                            .customFontSemiBoldLocalize(size: 16)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(categories, id: \.title) { category in
                                    NavigationLink(destination: destinationView(for: category.title)) {
                                        CategoryCardView(
                                            title: LocalizedStringKey(category.title),
                                            image: category.image,
                                            color: category.color,
                                            x: category.x,
                                            y: category.y
                                        )
                                    }
                                }
                            }
                        }
                    }

                    Spacer().frame(height: 30)

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
                                    .offset(y:2)
                            }
                        }
                    }

                    Spacer().frame(height: 20)
                    
                    // Scrollable Dishes (Show only a few cards)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            // Food on Sale Cards (Limited to 2)
                            ForEach(foodOnSaleViewModel.foodOnSaleItems.prefix(2)) { foodSale in
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
                                        .frame(width: 360)
                                }
                            }
                            
                            // Recipe/Food Cards from AddNewFoodVM (Limited to 2)
                            ForEach(addNewFoodVM.allNewFoodAndRecipes.prefix(2)) { recipe in
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
                                        .frame(width: 360)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
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
        }
        .environmentObject(foodOnSaleViewModel)
        .environmentObject(addNewFoodVM)
    }
    
    @ViewBuilder
    func destinationView(for title: String) -> some View {
        switch title {
        case "Breakfast":
            BreakfastScreenView()
        case "Lunch":
            LunchScreenView()
        case "Dinner":
            DinnerScreenView()
        case "Dessert":
            DessertScreenView()
        default:
            Text("Unknown Category")
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AddNewFoodVM()) // Preview requires providing the environment object explicitly
}
