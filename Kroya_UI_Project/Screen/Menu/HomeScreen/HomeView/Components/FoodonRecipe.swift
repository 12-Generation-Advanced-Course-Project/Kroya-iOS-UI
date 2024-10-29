//
//  FoodonRecipe.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 14/10/24.
//

import SwiftUI


struct FoodonRecipe: View {
    
    @Environment(\.dismiss) var dismiss
    let imageofOrder: [String] = ["SoupPic", "SaladPic", "GrillPic", "DessertPic 1"]
    let titleofOrder: [String] = ["Soup", "Salad", "Grill", "Dessert"]
    
    @State private var selectedOrderIndex: Int? = nil // Tracks selected index
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                //                NavigationLink(destination: SearchScreen()) {
                //                    HStack {
                //                        Image("ico_search1")
                //                            .resizable()
                //                            .scaledToFit()
                //                            .frame(width: 24, height: 24)
                //
                //                        Text("Search item")
                //                            .font(.customfont(.medium, fontSize: 16))
                //                            .foregroundColor(.gray)
                //                            .frame(width: .screenWidth * 0.26)
                //                            .padding(.trailing, 12)
                //
                //                        Spacer()
                //                    }
                //                    .padding(.leading, 12)
                //                    .frame(width: .screenWidth * 0.93, height: .screenHeight * 0.05)
                //                    .background(Color(hex: "#F3F2F3"))
                //                    .cornerRadius(12)
                //                }
                
                // Loop through images and titles
                HStack(spacing: 20) {
                    ForEach(0..<imageofOrder.count, id: \.self) { index in
                        Button(action: {
                            selectedOrderIndex = index // Update the selected index
                        }) {
                            VStack {
                                Image(imageofOrder[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                                Text(titleofOrder[index])
                                    .font(.customfont(.medium, fontSize: 16))
                                    .foregroundColor(selectedOrderIndex == index ? Color.yellow : Color.gray)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                Spacer().frame(height: 20)
                Text("All")
                    .font(.customfont(.bold, fontSize: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black.opacity(0.8))
                    .padding(.horizontal)
                
                                ScrollView(.vertical,showsIndicators: false) {
                                    VStack{
                                        NavigationLink(destination:
                                                        FoodDetailView(
                                                            theMainImage: "Songvak",
                                                            subImage1: "ahmok",
                                                            subImage2: "brohok",
                                                            subImage3: "SomlorKari",
                                                            subImage4: "Songvak"
                                                        )
//                                                        ContentOnButtonSheet(
//                                            foodName: "Somlor Kari",
//                                            price: 2.00,
//                                            date: "30 Sep 2024",
//                                            itemFood: "Somlor Kari",
//                                            profile: "profile_image",
//                                            userName: "User Name",
//                                            description: "Somlor Kari is a traditional Cambodian dish",
//                                            ingredients: "Chicken, Coconut Milk, Curry Paste",
//                                            percentageOfRating: 4.8,
//                                            numberOfRating: 200,
//                                            review: "Delicious dish!",
//                                            reviewDetail: "The Somlor Kari was perfectly spiced and rich in flavor"
//                                        )
                                        ){
                                            FoodandRecipeCardView(
                                                imageName: "SomlorKari",
                                                dishName: "Somlor Kari",
                                                cookingDate: "30 Sep 2024",
                                                price: 2.00,
                                                rating: 5.0,
                                                reviewCount: 200,
                                                deliveryInfo: "Free",
                                                deliveryIcon: "motorbike",
                                                framewidth:340,
                                                frameheight:200,
                                                frameWImage:605,
                                                frameHImage:180,
                                                Spacing: .screenWidth * 0.55,
                                                offset:.screenHeight * -(0.06),
                                                isRecipeorFood: true
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
//                                                        ContentOnButtonSheet(
//                                            foodName: "Somlor Kari",
//                                            price: 2.00,
//                                            date: "30 Sep 2024",
//                                            itemFood: "Somlor Kari",
//                                            profile: "profile_image",
//                                            userName: "User Name",
//                                            description: "Somlor Kari is a traditional Cambodian dish",
//                                            ingredients: "Chicken, Coconut Milk, Curry Paste",
//                                            percentageOfRating: 4.8,
//                                            numberOfRating: 200,
//                                            review: "Delicious dish!",
//                                            reviewDetail: "The Somlor Kari was perfectly spiced and rich in flavor"
//                                        )
                                        ){
                                            FoodandRecipeCardView(
                                                imageName: "food_background",
                                                dishName: "Khmer Food",
                                                cookingDate: "30 Sep 2024",
                                                price: 10.00,
                                                rating: 5.0,
                                                reviewCount: 200,
                                                deliveryInfo: "Free",
                                                deliveryIcon: "motorbike",
                                                framewidth:340,
                                                frameheight:200,
                                                frameWImage:405,
                                                frameHImage:180,
                                                Spacing: .screenWidth * 0.55,
                                                offset:.screenHeight * -(0.06),
                                                isRecipeorFood: true
                                            )
                                        }
                                    }
                                }
                                Spacer()
                
                RecipeView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.black)
                        }
                        Text("Food recipe")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundStyle(.black.opacity(0.8))
                    }
                }
            }
            
        }
        .searchable(text: $searchText, prompt: "Search Item")
        .navigationBarBackButtonHidden(true)
    }
}
#Preview{
    FoodonRecipe()
}
