

import SwiftUI
import SDWebImageSwiftUI
struct RecipeViewCell: View {
    var recipe: FoodRecipeModel
    var foodId: Int
    var itemType: String
    @State var isFavorite: Bool
    @StateObject private var favoriteVM = FavoriteVM()
    private let urlImagePrefix = "https://kroya-api-production.up.railway.app/api/v1/fileView/"

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                // Construct the full URL for the image
                if let photoFilename = recipe.photo.first?.photo, let url = URL(string: urlImagePrefix + photoFilename) {
                    WebImage(url: url)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .cornerRadius(15, corners: [.topLeft, .topRight])
                        .clipped()
                } else {
                    // Placeholder image when no URL is available
                    Image("placholder")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .cornerRadius(15, corners: [.topLeft, .topRight])
                        .clipped()
                }

                // Rating and Favorite Button
                HStack {
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.yellow)

                        Text(String(format: "%.1f", recipe.averageRating ?? 0))
                            .font(.customfont(.medium, fontSize: 12))
                            .foregroundColor(.black)

                        Text("(\(recipe.totalRaters ?? 0)+)")
                            .font(.customfont(.medium, fontSize: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(5)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.15), radius: 5, y: 4)

                    Spacer()

                    if Auth.shared.hasAccessToken(){
                        // Favorite Button
                        Button(action: {
                            isFavorite.toggle() // Toggle locally for UI responsiveness
                            favoriteVM.toggleFavorite(foodId: recipe.id, itemType: recipe.itemType, isCurrentlyFavorite: !isFavorite)
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
                    } else {
                        // Favorite Button
                        
                        Button(action: {
                            isFavorite.toggle() // Toggle locally for UI responsiveness
                        }) {
                            Circle()
                                .fill( Color.white.opacity(0.5))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16))
                                )
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 10)
            }
            .frame(height: 140)

            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.name)
                    .font(.customfont(.medium, fontSize: 14))
                    .foregroundColor(.black)

                Text(recipe.description ?? "" )
                    .customFontMedium(size: 14)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)

                HStack {
                    if recipe.itemType == "FOOD_RECIPE" {
                        Text("Recipe")
                            .customFontMedium(size: 12)
                            .foregroundColor(.yellow)
                    }

                    Text(recipe.level ?? "")
                        .customFontMedium(size: 12)
                        .foregroundColor(.gray)

                    Spacer()
                }
            }
            .padding(10)
            .frame(width: 350)
        }
        .onAppear {
            favoriteVM.getAllFavoriteFood()
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




struct RecipeViewCellForTest: View {
    var recipe: FoodRecipeModel
    var foodId: Int
    var itemType: String
    @State var isFavorite: Bool
    @StateObject private var favoriteVM = FavoriteVM()
    private let urlImagePrefix = "https://kroya-api-production.up.railway.app/api/v1/fileView/"
    var onFavoritechange: () -> Void
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                // Construct the full URL for the image
                if let photoFilename = recipe.photo.first?.photo, let url = URL(string: urlImagePrefix + photoFilename) {
                    WebImage(url: url)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .cornerRadius(15, corners: [.topLeft, .topRight])
                        .clipped()
                } else {
                    // Placeholder image when no URL is available
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .cornerRadius(15, corners: [.topLeft, .topRight])
                        .clipped()
                }

                // Rating and Favorite Button
                HStack {
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.yellow)

                        Text(String(format: "%.1f", recipe.averageRating ?? 0))
                            .font(.customfont(.medium, fontSize: 12))
                            .foregroundColor(.black)

                        Text("(\(recipe.totalRaters ?? 0)+)")
                            .font(.customfont(.medium, fontSize: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(5)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.15), radius: 5, y: 4)

                    Spacer()

                    if Auth.shared.hasAccessToken(){
                        // Favorite Button
                        Button(action: {
                            isFavorite.toggle()
                            favoriteVM.toggleFavorite(foodId: recipe.id, itemType: recipe.itemType, isCurrentlyFavorite: !isFavorite)
                            onFavoritechange()
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
                    } else {
                        // Favorite Button
                        
                        Button(action: {
                            isFavorite.toggle()
                        }) {
                            Circle()
                                .fill( Color.white.opacity(0.5))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16))
                                )
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 10)
            }
            .frame(height: 140)

            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.name)
                    .font(.customfont(.medium, fontSize: 14))
                    .foregroundColor(.black)

                Text(recipe.description ?? "" )
                    .customFontMedium(size: 14)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)

                HStack {
                    if recipe.itemType == "FOOD_RECIPE" {
                        Text("Recipe")
                            .customFontMedium(size: 12)
                            .foregroundColor(.yellow)
                    }

                    Text(recipe.level ?? "")
                        .customFontMedium(size: 12)
                        .foregroundColor(.gray)

                    Spacer()
                }
            }
            .padding(10)
            .frame(width: 350)
        }
        .onAppear {
            favoriteVM.getAllFavoriteFood()
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
