import SwiftUI

struct FoodOnSaleViewCell: View {
    
    @State private var isFavorite: Bool
    var foodSale: FoodOnSaleModel

    init(foodSale: FoodOnSaleModel, isFavorite: Bool = false) {
        self.foodSale = foodSale
        _isFavorite = State(initialValue: isFavorite)
    }

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                Image(foodSale.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .cornerRadius(15, corners: [.topLeft, .topRight])
                    .clipped()
                
                HStack {
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.yellow)
                        
                        Text(String(format: "%.1f", foodSale.rating))
                            .font(.customfont(.medium, fontSize: 11))
                            .foregroundColor(.black)
                        
                        Text("(\(foodSale.reviewCount)+)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(3)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: PrimaryColor.normal.opacity(0.25), radius: 5, y: 4)
                    
                    Spacer()
                    
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
                .padding(.trailing, 10)
            }
            .frame(height: 140)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(foodSale.dishName)
                    .font(.customfont(.medium, fontSize: 14))
                    .foregroundColor(.black)
                
                HStack {
                    Text("It will be cooked on ")
                        .font(.customfont(.light, fontSize: 9))
                        .foregroundColor(.gray) +
                    
                    Text(foodSale.cookingDate)
                        .font(.customfont(.light, fontSize: 9))
                        .foregroundColor(.yellow) +
                    
                    Text(" in the morning.")
                        .font(.customfont(.medium, fontSize: 9))
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 10) {
                    Text("$ \(String(format: "%.2f", foodSale.price))")
                        .font(.customfont(.medium, fontSize: 14))
                        .foregroundColor(.yellow)
                    
                    HStack(spacing: 4) {
                        Image(foodSale.deliveryIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .opacity(0.60)
                        Text(foodSale.deliveryInfo)
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
