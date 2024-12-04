import SwiftUI
import SDWebImageSwiftUI

struct FoodOnSaleViewCell: View {
    var foodSale: FoodSellModel
    var foodId: Int
    var itemType: String
    @State var isFavorite: Bool
    @StateObject private var favoriteVM = FavoriteVM()
    @State private var isFavoriteupdate: Bool = false

    private let urlImagePrefix = "http://35.247.138.88:8080/api/v1/fileView/"

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                // Main Image
                if let photoFilename = foodSale.photo.first?.photo, let url = URL(string: urlImagePrefix + photoFilename) {
                    WebImage(url: url)
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

                    if Auth.shared.hasAccessToken() {
                        // Favorite Button
                        Button(action: {
                            toggleFavoriteStatus()
                        }) {
                            Circle()
                                .fill(isFavoriteupdate ? Color.red : Color.white.opacity(0.5))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16))
                                )
                        }
                        .shadow(color: isFavoriteupdate ? Color.red.opacity(0.5) : Color.gray.opacity(0.5), radius: 4, x: 0, y: 4)
                        .onAppear {
                            isFavoriteupdate = foodSale.isFavorite ?? false
                        }
                    } else {
                        // Favorite Button for unauthenticated users
                        Button(action: {
                            isFavorite.toggle() // Toggle locally for UI responsiveness
                        }) {
                            Circle()
                                .fill(Color.white.opacity(0.5))
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
            .onAppear {
                favoriteVM.getAllFavoriteFood()
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(foodSale.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)

                if let cookingDate = foodSale.dateCooking {
                    Text("It will be cooked on \(formatDate(cookingDate)) \(determineTimeOfDay(from: cookingDate))")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }

                HStack(spacing: 10) {
                    // Price
                    Text("\(currencySymbol(for: foodSale.currencyType ?? "")) \(String(format: "%.2f", foodSale.price))")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.yellow)

                    HStack(spacing: 4) {
                        Image(.motorbike)
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

    // MARK: - Helper Functions
    private func toggleFavoriteStatus() {
        guard let currentFavoriteStatus = foodSale.isFavorite else { return }
        let newFavoriteStatus = !currentFavoriteStatus
        isFavoriteupdate = newFavoriteStatus

        favoriteVM.toggleFavorite(foodId: foodId, itemType: itemType, isCurrentlyFavorite: currentFavoriteStatus)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if favoriteVM.showError {
                isFavoriteupdate = currentFavoriteStatus
            }
        }
    }

    private func currencySymbol(for currencyType: String) -> String {
        switch currencyType {
        case "DOLLAR": return "$"
        case "RIEL": return "៛"
        default: return ""
        }
    }

    private func formatDate(_ dateString: String) -> String {
        let dateFormats = ["yyyy-MM-dd'T'HH:mm:ss.SSS", "yyyy-MM-dd'T'HH:mm:ss"]
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        for format in dateFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                formatter.dateFormat = "dd MMM yyyy"
                return formatter.string(from: date)
            }
        }
        return "Invalid Date"
    }

    private func determineTimeOfDay(from dateString: String) -> String {
        guard let date = parseDate(dateString) else { return "at current time." }
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 5..<12: return "in the morning."
        case 12..<17: return "in the afternoon."
        case 17..<21: return "in the evening."
        default: return "at night."
        }
    }

    private func parseDate(_ dateString: String) -> Date? {
        let dateFormats = ["yyyy-MM-dd'T'HH:mm:ss.SSS", "yyyy-MM-dd'T'HH:mm:ss"]
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        for format in dateFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }
}


struct FoodOnSaleViewCellForTest: View {
    var foodSale: FoodSellModel
    var foodId: Int
    var itemType: String
    @State var isFavorite: Bool
    @StateObject private var favoriteVM = FavoriteVM()
    var onFavoritechange: () -> Void
    private let urlImagePrefix = "https://kroya-api-production.up.railway.app/api/v1/fileView/"

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                // Main Image
                if let photoFilename = foodSale.photo.first?.photo, let url = URL(string: urlImagePrefix + photoFilename) {
                    WebImage(url: url)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .cornerRadius(15, corners: [.topLeft, .topRight])
                        .clipped()
                } else {
                    Image(.placholder)
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
                            .font(.system(size: 12, weight: .medium))
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

                    if Auth.shared.hasAccessToken(){
                        // Favorite Button
                        // Updated Favorite Button Logic
                        Button(action: {
                            isFavorite.toggle()
                            favoriteVM.toggleFavorite(foodId: foodSale.id, itemType: foodSale.itemType, isCurrentlyFavorite: !isFavorite)
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
            .onAppear {
                // Fetch the favorite state on appear
                favoriteVM.getAllFavoriteFood()
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(foodSale.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)

                if let cookingDate = foodSale.dateCooking {
                    Text("It will be cooked on \(formatDate(cookingDate)) \(determineTimeOfDay(from: cookingDate))")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }

                HStack(spacing: 10) {
                    // update cuurncy symbol
                    Text("\(currencySymbol(for: foodSale.currencyType ?? "")) \(String(format: "%.2f", foodSale.price))")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.yellow)


                    HStack(spacing: 4) {
                        Image(.motorbike)
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
    // MARK: - Helper Functions
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

    // Helper functions for date and time remain unchanged
    private func parseDate(_ dateString: String) -> Date? {
        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSS",  // With milliseconds
            "yyyy-MM-dd'T'HH:mm:ss"       // Without milliseconds
        ]
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        for format in dateFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }

    private func formatDate(_ dateString: String) -> String {
        guard let date = parseDate(dateString) else { return "Invalid Date" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
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
