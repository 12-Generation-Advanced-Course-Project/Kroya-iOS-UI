

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
                // Display the first photo or a placeholder
//                if let firstImageName = recipe.photos.first?.photo {
//                    let imageUrl = URL(string: "https://kroya-api.up.railway.app/api/v1/fileView/\(firstImageName)")
//                    KFImage(imageUrl)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(height: 160)
//                        .cornerRadius(15, corners: [.topLeft, .topRight])
//                        .clipped()
//                } else {
//
//                }
                Image(.mixue)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .cornerRadius(15, corners: [.topLeft, .topRight])
                    .clipped()
                // Display rating and favorite button
                HStack {
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.yellow)
                        
                        Text(String(format: "%.1f", recipe.rating ?? 4.5))
                            .font(.customfont(.medium, fontSize: 11))
                            .foregroundColor(.black)
                        
                        Text("(\(recipe.reviewCount ?? 100)+)")
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
            
            // Display details (e.g., name, level, duration, and optional sale information)
            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.name)
                    .font(.customfont(.medium, fontSize: 14))
                    .foregroundColor(.black)
                HStack {
                    // Display description if item is a recipe
                    Text(recipe.description)
                        .font(.customfont(.light, fontSize: 9))
                        .foregroundColor(.gray)
                        .lineLimit(2) // Limit lines for a cleaner look
                }
                // Show level and duration
                HStack(spacing: 10) {
                    Text(recipe.level)
                        .font(.customfont(.medium, fontSize: 14))
                        .foregroundColor(.yellow)
                    
                    Text(recipe.durationInMinutes > 0 ? "\(recipe.durationInMinutes) min" : "N/A")
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
                .stroke(Color(hex: "#E6E6E6"), lineWidth: 0.5)
        }
    }
    // Helper to get the path to the app's Documents directory
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveImageToDocumentsDirectory(image: UIImage, fileName: String) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let url = getDocumentsDirectory().appendingPathComponent(fileName)
            do {
                try data.write(to: url)
                print("Image saved to \(url.path)")
            } catch {
                print("Failed to save image: \(error)")
            }
        }
    }

}
