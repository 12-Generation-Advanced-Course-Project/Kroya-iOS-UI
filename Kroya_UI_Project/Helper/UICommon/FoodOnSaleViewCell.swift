//
//  FoodOnSaleView.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 22/10/24.
//


import SwiftUI

struct FoodOnSaleViewCell: View {
    
    @State private var isFavorite: Bool = false
    
    var imageName           : String
    var dishName            : String
    var cookingDate         : String
    var price               : Double
    var rating              : Double
    var reviewCount         : Int
    var deliveryInfo        : String
    var deliveryIcon        : String
    
    
    var body: some View {
        
        VStack {
            ZStack(alignment: .topLeading) {  // Aligns everything to the top leading (left)
                
                // Image Section
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160) // Fixed height for the image as shown in the sample UI
                    .cornerRadius(15, corners: [.topLeft, .topRight])
                    .clipped()
                
                HStack {
                    // Rating and Reviews Section
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.yellow)
                        
                        Text(String(format: "%.1f", rating))
                            .font(.customfont(.medium, fontSize: 11))
                            .foregroundColor(.black)
                        
                        Text("(\(reviewCount)+)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(3)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: PrimaryColor.normal.opacity(0.25),radius: 5,y:4)
                    
                    Spacer()  // Push the Favorite button to the right
                    
                    // Favorite Button
                    Button(action: {
                        isFavorite.toggle()
                    }) {
                        Circle()
                            .fill(isFavorite ? Color.red : Color.white.opacity(0.5))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            )
                    }
                }
                .padding(.top, 20)
                .padding(.leading, 10)
                .padding(.trailing, 10)  // Padding added for right spacing
            }
            .frame(height: 140)
            
            // Content Section
            VStack(alignment: .leading, spacing: 5) {
                // Dish Name
                Text(dishName)
                    .font(.customfont(.medium, fontSize: 14))  // Dynamic font size
                    .foregroundColor(.black)
                
                // Cooking Date Information
                HStack {
                    Text("It will be cooked on ")
                        .font(.customfont(.light, fontSize:9))
                        .foregroundColor(.gray) +
                    
                    Text(cookingDate)
                        .font(.customfont(.light, fontSize: 9))
                        .foregroundColor(.yellow) +
                    
                    Text(" in the morning.")
                        .font(.customfont(.medium, fontSize: 9))
                        .foregroundColor(.gray)
                }
                
               
                // Price and Delivery Info
                HStack(spacing: 10){
                    Text("$ \(String(format: "%.2f", price))")
                        .font(.customfont(.medium, fontSize: 14))
                        .foregroundColor(.yellow)
                    
                    HStack(spacing: 4) {
                        Image(deliveryIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .opacity(0.60)
                        Text(deliveryInfo)
                            .font(.customfont(.light, fontSize: 12))
                            .foregroundColor(.gray)
                        
                    }
                    Spacer()
                    
//                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
               
            }
            .padding(10)
//            .frame(maxWidth: .infinity)
            .frame(width: 350)
        }
       
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 4)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(hex: "#E6E6E6"), lineWidth: 0.8)
        }
    }
}

#Preview {
    
    FoodOnSaleViewCell(
        
        imageName: "food7", // Make sure this is the correct image in your assets
        dishName: "Baycha Loklak",
        cookingDate: "30 Sep 2024",
        price: 2.00,
        rating: 5.0,
        reviewCount: 200,
        deliveryInfo: "Free",
        deliveryIcon: "motorbike"
    )
}
