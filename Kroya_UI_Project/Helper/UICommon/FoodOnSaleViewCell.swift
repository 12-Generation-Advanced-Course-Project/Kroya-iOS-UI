import SwiftUI
import Kingfisher

struct FoodOnSaleViewCell: View {
      var foodSale: FoodSellModel
      @StateObject private var favoriteFoodSale = FavoriteVM()
      @State private var isFavorite: Bool
       let onFavoriteToggle: (Int) -> Void  // Callback to notify favorite toggle
       private let urlImagePrefix = "https://kroya-api-production.up.railway.app/api/v1/fileView/"
       
       init(foodSale: FoodSellModel, isFavorite: Bool = false, onFavoriteToggle: @escaping (Int) -> Void) {
           self.foodSale = foodSale
           self._isFavorite = State(initialValue: isFavorite)
           self.onFavoriteToggle = onFavoriteToggle
       }
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                // Main Image
                if let photoFilename = foodSale.photo.first?.photo, let url = URL(string: urlImagePrefix + photoFilename) {
                    KFImage(url)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .cornerRadius(15, corners: [.topLeft, .topRight])
                        .clipped()
                } else {
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
                        
                        Text(String(format: "%.1f", foodSale.averageRating ?? 0.0))
                            .font(.customfont(.medium, fontSize: 12))
                            .foregroundColor(.black)
                        
                        Text("(\(String(describing: foodSale.totalRaters ?? 0))+)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(5)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.15), radius: 5, y: 4)
                    
                    Spacer()
                    
                    // Favorite Button
                    Button(action: {
                                    isFavorite.toggle()
                                    onFavoriteToggle(foodSale.id)  // Notify the parent to toggle favorite
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
                Text(foodSale.name)
                    .font(.customfont(.medium, fontSize: 16))
                    .foregroundColor(.black)
                
                HStack(spacing: 10) {
                    Text("$ \(String(format: "%.2f", foodSale.price))")
                        .font(.customfont(.medium, fontSize: 14))
                        .foregroundColor(.yellow)
                    
                    HStack(spacing: 4) {
                        Image(.motorbike)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .opacity(0.60)
                        Text("Free")
                            .font(.customfont(.light, fontSize: 12))
                            .foregroundColor(.gray)
                    }
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
