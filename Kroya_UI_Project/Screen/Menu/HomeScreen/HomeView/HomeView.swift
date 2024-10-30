import SwiftUI

struct Category {
    let title: String
    let image: String
    let color: Color
    let x: CGFloat
    let y: CGFloat
}

struct HomeView: View {
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
                            .font(.customfont(.semibold, fontSize: 24))

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
                            .font(.customfont(.semibold, fontSize: 16))

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
                            .font(.customfont(.semibold, fontSize: 16))
                        Spacer()
                        NavigationLink {
                            ViewAllPopularDishesView()
                        } label: {
                            Text(LocalizedStringKey("View all -->"))
                                .foregroundStyle(PrimaryColor.normal)
                                .font(.customfont(.semibold, fontSize: 16))
                                .offset(x: -10)
                        }
                    }

                    Spacer().frame(height: 20)

                    // Scrollable Dishes
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            NavigationLink(destination:
                                            FoodDetailView(
                                                theMainImage: "Songvak",
                                                subImage1: "ahmok",
                                                subImage2: "brohok",
                                                subImage3: "SomlorKari",
                                                subImage4: "Songvak",
                                                showPrice1: true
                                            )
                            
                            ) {
                                FoodOnSaleViewCell(
                                    imageName: "brohok",
                                    dishName: "Somlor Kari",
                                    cookingDate: "30 Sep 2024",
                                    price: 2.00,
                                    rating: 5.0,
                                    reviewCount: 200,
                                    deliveryInfo: "Free",
                                    deliveryIcon: "motorbike"
                                )
                            }

                                // Example PopularDishesCard for dishes
                                NavigationLink(destination:
                                                FoodDetailView(
                                                    theMainImage: "Songvak",
                                                    subImage1: "ahmok",
                                                    subImage2: "brohok",
                                                    subImage3: "SomlorKari",
                                                    subImage4: "Songvak",
                                                    showPrice1: true
                                                )
                                ) {
                                    FoodOnSaleViewCell(
                                        
                                        imageName: "food8",
                                        dishName: "Char Trorb",
                                        cookingDate: "30 Sep 2024",
                                        price: 2.00,
                                        rating: 5.0,
                                        reviewCount: 200,
                                        deliveryInfo: "Free",
                                        deliveryIcon: "motorbike"
                                    )
                                }
                                
                                NavigationLink(destination:
                                                FoodDetailView(
                                                    theMainImage: "Songvak",
                                                    subImage1: "ahmok",
                                                    subImage2: "brohok",
                                                    subImage3: "SomlorKari",
                                                    subImage4: "Songvak",
                                                    showOrderButton: false
                                                )
                                ) {
                                    RecipeViewCell(
                                        
                                        imageName           : "food9",
                                        dishName            : "Stack",
                                        cookingDate         : "30 Sep 2024",
                                        statusType          : "Recipe",
                                        rating              : 5.0,
                                        reviewCount         : 200,
                                        level               : "Easy"
                                        
                                    )
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
                                                .stroke(Color.white, lineWidth: 1) // Optional white border around the badge
                                        )
                                        .offset(x: 10, y: -10) // Position badge on top of the notification icon
                                }
                            }
                        }
                    }
                }
            }
        }
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


#Preview {
    HomeView()
}
