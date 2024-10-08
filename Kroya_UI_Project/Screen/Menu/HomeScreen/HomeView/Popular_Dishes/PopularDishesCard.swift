import SwiftUI

struct CardView: View {
    @State private var isFavorite: Bool = false
    
    var imageName: String
    var dishName: String
    var cookingDate: String
    var price: Double
    var rating: Double
    var reviewCount: Int
    var deliveryInfo: String
    var deliveryIcon: String
    
    var body: some View {
        VStack {
            // Image with heart icon and rating
            ZStack(alignment: .topTrailing) {
                // Dish image (replace with your actual image)
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .cornerRadius(15)
                    .clipped()
                
                // Heart icon as a button
                Button(action: {
                    isFavorite.toggle() // Toggle the heart icon state
                }) {
                    Circle()
                        .fill(isFavorite ? Color.red : Color.white.opacity(0.5))
                        .frame(width: 35, height: 35)
                        .overlay(
                            Image(systemName: "heart.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        )
                }
                .shadow(color: isFavorite ? Color.red.opacity(0.5) : Color.gray.opacity(0.5), radius: 4, x: 0, y: 4)
                .padding(.trailing, 10)
                .padding(.top, 10)
            }
            .overlay(
                // Rating and reviews
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", rating))
                        .font(.headline)
                        .foregroundColor(.black)
                    Text("(\(reviewCount)+)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(2)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .padding(.leading, 10)
                .padding(.top, 10),
                alignment: .topLeading
            )
            
            // Dish title
            HStack {
                Text(dishName)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 4)
            
            // Description of the cooking date
            HStack {
                Text("It will be cooked on ")
                    .font(.caption)
                    .foregroundColor(.gray) +
                Text(cookingDate)
                    .font(.caption)
                    .foregroundColor(.yellow) +
                Text(" in the morning.")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal)
            
            // Pricing and delivery information
            HStack {
                Text("$ \(String(format: "%.2f", price))")
                    .font(.caption)
                    .foregroundColor(.yellow)

                HStack(spacing: 4) {
                    Image(systemName: deliveryIcon)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(deliveryInfo)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 1)
        .padding(.horizontal)
    }
}

#Preview {
    CardView(
        imageName: "Songvak",
        dishName: "Somlor Kari",
        cookingDate: "30 Sep 2024",
        price: 2.00,
        rating: 5.0,
        reviewCount: 200,
        deliveryInfo: "Free",
        deliveryIcon: "bicycle"
    )
}
