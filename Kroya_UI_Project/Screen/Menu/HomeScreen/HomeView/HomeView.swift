

import SwiftUI

struct HomeView: View {
    
    let notification = [1, 2, 3, 4, 5]
    @StateObject private var recipeViewModel = RecipeViewModel()
    @StateObject private var foodSellViemModel = FoodSellViewModel()
    @StateObject private var categoryVM = CategoryMV()
    @StateObject private var guestCategoryVM = GuestCategoryVM()
    @StateObject private var guestFoodSellVM = GuestFoodOnSaleVM()
    @StateObject private var guestFoodRecipeVM = GuestFoodRecipeVM()
    @State var isSearching: Bool = false
    @Environment(\.locale) var locale
    @StateObject private var recentSearchesData = RecentSearchesData()
    @StateObject private var PopularFoodsData =  PopularFoodVM()
    @StateObject private var favoriteVM = FavoriteVM()
    @StateObject private var notificationVM = NotificationViewModel()
    @Environment(\.modelContext) var modelContext
    @State var isLoading: Bool = false
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
                            NavigationLink(destination: FoodonOrderView()
                            ) {
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
                    
                    // category
                    VStack(alignment: .leading, spacing: 8) {
                        Text(LocalizedStringKey("Category"))
                            .customFontSemiBoldLocalize(size: 16)
                            .padding(.horizontal)
                        
                        if Auth.shared.hasAccessToken(){
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(categoryVM.displayCategories, id: \.id) { category in
                                        
                                        NavigationLink(destination: CategoryFoodDetails(category: category)){
                                            CategoryCardView(
                                                title: LocalizedStringKey(category.title.rawValue),
                                                image: category.image,
                                                color: category.color,
                                                x: category.x,
                                                y: category.y
                                            )
                                        }
                                        .onTapGesture {
                                            // Fetch data for the selected category by ID
                                            print("this is Id \(category.id)")
                                            categoryVM.fetchAllCategoryById(categoryId: category.id)
                                        }
                                    }
                                    
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(guestCategoryVM.displayGuestCategories, id: \.id) { category in
                                        
                                        NavigationLink(destination: CategoryFoodDetails(category: category)){
                                            CategoryCardView(
                                                title: LocalizedStringKey(category.title.rawValue),
                                                image: category.image,
                                                color: category.color,
                                                x: category.x,
                                                y: category.y
                                            )
                                        }
                                        .onTapGesture {
                                            // Fetch data for the selected category by ID
                                            print("this is Id \(category.id)")
                                            guestCategoryVM.fetchAllfoodByCategoryId(categoryId: category.id)
                                        }
                                    }
                                    
                                }
                                .padding(.horizontal)
                            }
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
<<<<<<< HEAD
                            // Food on Sale Cards (Limited to 2)
                            ForEach(PopularFoodsData.popularFoodSell.prefix(2)) { foodSale in
                                NavigationLink(destination:
                                                FoodDetailView(
                                                    isFavorite: foodSale.isFavorite ?? false, showPrice: true, // Always false for recipes
                                                showOrderButton: true, // Always false for recipes
                                                showButtonInvoic: nil, // Not applicable
                                                invoiceAccept: nil, // Not applicable
                                                FoodId: foodSale.id,
                                                ItemType: foodSale.itemType
                                            )
                                ) {
                                    FoodOnSaleViewCell(
                                        foodSale: foodSale,
                                        foodId: foodSale.id,
                                        itemType: "FOOD_SELL",
                                        isFavorite: foodSale.isFavorite ?? false
                                    )
                                    .frame(width: 350)
                                }
                            }
                            
                            // Recipe/Food Cards from AddNewFoodVM (Limited to 2)
                            ForEach(PopularFoodsData.popularFoodRecipe.prefix(2)) { recipe in
                                NavigationLink(destination:
                                                FoodDetailView(
                                                    isFavorite: recipe.isFavorite ?? false, showPrice: false, // Always false for recipes
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
                                        isFavorite: recipe.isFavorite ?? false
                                    )
                                    .frame(width: 350)
=======
                            if Auth.shared.hasAccessToken(){
                                // Food on Sale Cards (Limited to 2)
                                ForEach(foodSellViemModel.FoodOnSale) { foodSale in
                                    NavigationLink(destination:
                                                    FoodDetailView(
                                                        isFavorite: foodSale.isFavorite ?? false, showPrice: true, // Always false for recipes
                                                    showOrderButton: true, // Always false for recipes
                                                    showButtonInvoic: nil, // Not applicable
                                                    invoiceAccept: nil, // Not applicable
                                                    FoodId: foodSale.id,
                                                    ItemType: foodSale.itemType
                                                )
                                    ) {
                                        FoodOnSaleViewCell(
                                            foodSale: foodSale,
                                            foodId: foodSale.id,
                                            itemType: "FOOD_SELL",
                                            isFavorite: foodSale.isFavorite ?? false
                                        )
                                        .frame(width: 350)
                                    }
                                }
                                
                                // Recipe/Food Cards from AddNewFoodVM (Limited to 2)
                                ForEach(recipeViewModel.RecipeFood) { recipe in
                                    NavigationLink(destination:
                                                    FoodDetailView(
                                                        isFavorite: recipe.isFavorite ?? false, showPrice: false, // Always false for recipes
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
                                            isFavorite: recipe.isFavorite ?? false
                                        )
                                        .frame(width: 350)
                                    }
                                }
                            } else {
                                // Food on Sale Cards (Limited to 2)
                                ForEach(guestFoodSellVM.GuestFoodOnSale.prefix(3)) { foodSale in
                                    NavigationLink(destination:
                                                    FoodDetailView(
                                                        isFavorite: foodSale.isFavorite ?? false, showPrice: true, // Always false for recipes
                                                    showOrderButton: true, // Always false for recipes
                                                    showButtonInvoic: nil, // Not applicable
                                                    invoiceAccept: nil, // Not applicable
                                                    FoodId: foodSale.id,
                                                    ItemType: foodSale.itemType
                                                )
                                    ) {
                                        FoodOnSaleViewCell(
                                            foodSale: foodSale,
                                            foodId: foodSale.id,
                                            itemType: "FOOD_SELL",
                                            isFavorite: foodSale.isFavorite ?? false
                                        )
                                        .frame(width: 350)
                                    }
                                }
                                
                                // Recipe/Food Cards from AddNewFoodVM (Limited to 2)
                                ForEach(guestFoodRecipeVM.GuestFoodRecipe.prefix(3)) { recipe in
                                    NavigationLink(destination:
                                                    FoodDetailView(
                                                        isFavorite: recipe.isFavorite ?? false, showPrice: false, // Always false for recipes
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
                                            isFavorite: recipe.isFavorite ?? false
                                        )
                                        .frame(width: 350)
                                    }
>>>>>>> 0dd4d10 (fetch guest popular on view and guest food recipe)
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
                        NavigationLink(destination:
                                        SearchScreen(recentSearchesData: recentSearchesData)
                            .environment(\.modelContext, modelContext)
                        ) {
                            Image("ico_search")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.black)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: NotificationView()) {
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
            .refreshable {
                           await refreshData() // Calls the refresh logic
            }
            .onAppear {
                loadData()
            }
        }
    }
    // MARK: - Fetch Data Logic
      private func loadData() {
          categoryVM.fetchAllCategory()
          recipeViewModel.getAllRecipeFood()
          foodSellViemModel.getAllFoodSell()
          recentSearchesData.loadSearches(from: modelContext)
          PopularFoodsData.getAllPopular()
          favoriteVM.getAllFavoriteFood()
          guestCategoryVM.fetchAllGuestCategory()
          guestFoodSellVM.getAllGuestFoodSell()
          guestFoodRecipeVM.getAllGuestRecipeFood()
          
      }
    private func refreshData() async {
           isLoading = true // Start loading state
           defer { isLoading = false } // Ensure state is reset after execution

           // Simulate a delay for demo purposes
           try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay

           // Reload data
           await MainActor.run {
               loadData()
           }
       }
}





