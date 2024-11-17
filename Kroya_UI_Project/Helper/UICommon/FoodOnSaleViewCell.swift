import SwiftUI
import Kingfisher
import SDWebImageSwiftUI

struct FoodOnSaleViewCell: View {
    var foodSale: FoodSellModel
    @State private var isFavorite: Bool
    let onFavoriteToggle: (Int) -> Void  // Callback to notify parent of favorite toggle
    
    private let urlImagePrefix = "https://kroya-api-production.up.railway.app/api/v1/fileView/"
    
    init(foodSale: FoodSellModel, isFavorite: Bool = false, onFavoriteToggle: @escaping (Int) -> Void) {
        self.foodSale = foodSale
        self._isFavorite = State(initialValue: isFavorite)
        self.onFavoriteToggle = onFavoriteToggle
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                // Display Main Image
                if let photoFilename = foodSale.photo.first?.photo,
                   let url = URL(string: urlImagePrefix + photoFilename) {
                    WebImage(url: url)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .cornerRadius(15, corners: [.topLeft, .topRight])
                        .clipped()
                } else {
                    // Placeholder image if no photo available
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .cornerRadius(15, corners: [.topLeft, .topRight])
                        .clipped()
                }
                
                // Rating and Favorite Button
                HStack {
                    // Star Rating Section
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.yellow)
                        
                        Text(String(format: "%.1f", foodSale.averageRating ?? 0.0))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.black)
                        
                        Text("(\(foodSale.totalRaters ?? 0)+)")
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
                        onFavoriteToggle(foodSale.id) // Notify the parent view of the toggle
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
                // Food Name
                Text(foodSale.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                // Cooking Date Information
                if let cookingDate = foodSale.dateCooking {
                    Text("It will be cooked on \(formatDate(cookingDate)) \(determineTimeOfDay(from: cookingDate))")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                
                HStack(spacing: 10) {
                    // Display currency symbol based on currencyType
                    Text("\(currencySymbol(for: foodSale.currencyType)) \(String(format: "%.2f", foodSale.price))")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.yellow)
                    
                    // Free Delivery Information
                    HStack(spacing: 4) {
                        Image(systemName: "bicycle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .opacity(0.60)
                        Text("Free")
                            .font(.system(size: 12, weight: .light))
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
    
    // MARK: - Helper function to get the currency symbol
    private func currencySymbol(for currencyType: String) -> String {
        switch currencyType {
        case "DOLLAR":
            return "$"
        case "RIEL":
            return "៛"
        default:
            return ""
        }
    }
    
    //MARK: Helper function to format date
    private func parseDate(_ dateString: String) -> Date? {
        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSS",  // With milliseconds
            "yyyy-MM-dd'T'HH:mm:ss"       // Without milliseconds
        ]
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure consistent parsing
        
        for format in dateFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        return nil // Return nil if none of the formats match
    }

    
    //MARK: Helper function to determine time of day based on the cook date time (if available)
    private func formatDate(_ dateString: String) -> String {
        guard let date = parseDate(dateString) else { return "Invalid Date" }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // Output format
        formatter.dateFormat = "dd MMM yyyy" // Example: "23 Nov 2024"
        return formatter.string(from: date)
    }

    private func determineTimeOfDay(from dateString: String) -> String {
        guard let date = parseDate(dateString) else { return "at current time." }
        let hour = Calendar.current.component(.hour, from: date)
        
        switch hour {
        case 5..<12:
            return "in the morning."
        case 12..<17:
            return "in the afternoon."
        case 17..<21:
            return "in the evening."
        default:
            return "at night."
        }
    }

}
