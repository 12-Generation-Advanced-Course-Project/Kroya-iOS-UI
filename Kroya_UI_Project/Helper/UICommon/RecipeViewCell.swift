

import SwiftUI
import Kingfisher

struct RecipeViewCell: View {
    var recipe: AddNewFoodModel
    @State private var isFavorite: Bool
    var urlImagePrefix: String = "https://kroya-api.up.railway.app/api/v1/fileView/"
    
    init(recipe: AddNewFoodModel, isFavorite: Bool = false) {
        self.recipe = recipe
        _isFavorite = State(initialValue: isFavorite)
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                // Display recipe image with NavigationLink only on the image and background
                Image(.chineseHotpot)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .cornerRadius(15, corners: [.topLeft, .topRight])
                    .clipped()
                // Rating and Favorite Button
                HStack {
                    // Rating Section
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.yellow)
                        
                        Text(String(format: "%.1f", recipe.rating ?? 0))
                            .font(.customfont(.medium, fontSize: 12))
                            .foregroundColor(.black)
                        
                        Text("(\(recipe.reviewCount ?? 0)+)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(5)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.15), radius: 5, y: 4)
                    
                    Spacer()
                    
                    // Favorite Button (outside of NavigationLink area)
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
                .padding(.horizontal, 10)
            }
            .frame(height: 140)
            
            VStack(alignment: .leading, spacing: 5) {
                // Dish Name
                Text(recipe.name)
                    .font(.customfont(.medium, fontSize: 14))
                    .foregroundColor(.black)
                
                // Description for Recipe
                Text(recipe.description)
                    .font(.customfont(.light, fontSize: 10))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                HStack {
                    // Status Type: "Recipe" label if not for sale
                    if !recipe.isForSale {
                        Text("Recipe")
                            .font(.customfont(.medium, fontSize: 12))
                            .foregroundColor(.yellow)
                    }
                    
                    // Difficulty Level
                    Text(recipe.level)
                        .font(.customfont(.light, fontSize: 12))
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
            .padding(10)
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
