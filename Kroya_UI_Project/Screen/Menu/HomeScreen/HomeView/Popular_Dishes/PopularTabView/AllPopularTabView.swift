

import SwiftUI

struct AllPopularTabView: View {
    
    var isselected : Int?
    
    var body: some View {
        ScrollView(.vertical,showsIndicators: false) {
            
            VStack{
                // Example PopularDishesCard for dishes
                NavigationLink(destination:
                                FoodDetailView(
                                    theMainImage: "Songvak",
                                    subImage1: "ahmok",
                                    subImage2: "brohok",
                                    subImage3: "SomlorKari",
                                    subImage4: "Songvak"
                                )
                               //                                ContentOnButtonSheet(
                               //                    foodName: "somlor Kari",
                               //                    price: 2.00,
                               //                    date: "30 Sep 2024",
                               //                    itemFood: "Somlor Kari",
                               //                    profile: "profile_image",
                               //                    userName: "User Name",
                               //                    description: "Somlor Kari is a traditional Cambodian dish...",
                               //                    ingredients: "Chicken, Coconut Milk, Curry Paste",
                               //                    percentageOfRating: 4.8,
                               //                    numberOfRating: 200,
                               //                    review: "Delicious dish!",
                               //                    reviewDetail: "The Somlor Kari was perfectly spiced and rich in flavor"
                               //                )
                ) {
                    FoodOnSaleViewCell(
                        
                        imageName: "brohok", // Make sure this is the correct image in your assets
                        dishName: "Somlor Kari",
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
                                    subImage4: "Songvak"
                                )
                               //                                ContentOnButtonSheet(
                               //                    foodName: "Songvak",
                               //                    price: 2.00,
                               //                    date: "30 Sep 2024",
                               //                    itemFood: "Songvak",
                               //                    profile: "profile_image", // Assuming a profile image
                               //                    userName: "User Name",
                               //                    description: "Songvak is a delicious dish...",
                               //                    ingredients: "Pork, Fish Sauce, Spices",
                               //                    percentageOfRating: 4.7,
                               //                    numberOfRating: 150,
                               //                    review: "Fantastic!",
                               //                    reviewDetail: "The dish was flavorful and aromatic, a great meal..."
                               //                )
                ) {
                    RecipeViewCell(
                        
                        imageName           : "Songvak",
                        dishName            : "Somlor Kari",
                        cookingDate         : "30 Sep 2024",
                        statusType          : "Recipe",
                        rating              : 5.0,
                        reviewCount         : 200,
                        level               : "Easy"
                        
                    )
                }
            }
            .padding(.horizontal)
            
        }
    }
}

#Preview {
    AllPopularTabView()
}
