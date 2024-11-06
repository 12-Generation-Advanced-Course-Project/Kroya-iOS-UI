import SwiftUI

struct Review: View {
    @State private var isExpanded = false
    @State private var isReviewExpanded = false
    @State private var isReviewPopupOpen = false
    @State private var selectedRating: Int = 0
    @State private var description = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                // User review
                HStack {
                    Text("Tap to Rate")
                        .font(.customfont(.regular, fontSize: 18))
                        .foregroundStyle(Color.gray)
                    Spacer()
                    HStack(spacing: 2) {
                        ForEach(1..<6) { star in
                            Image(systemName: selectedRating >= star ? "star.fill" : "star")
                                .font(.system(size: geometry.size.width * 0.05))
                                .foregroundColor(selectedRating >= star ? .yellow : .gray)
                                .onTapGesture {
                                    selectedRating = (selectedRating == star) ? 0 : star
                                }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: geometry.size.height * 0.007) {
                    Text("A very good Recipe")
                        .font(.customfont(.semibold, fontSize: 14))
                    
                    // Star rating for the user's review
                    HStack(spacing: 2) {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill")
                                .font(.customfont(.regular, fontSize: 8))
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    Spacer().frame(height: geometry.size.height * 0.004)
                    
                    // Main review text with "more" or "less" toggle
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your profile.Your recipe has been uploaded, you can see it on your profile.")
                            .font(.customfont(.regular, fontSize: 14))
                            .foregroundStyle(Color(hex: "#2E3E5C"))
                            .lineLimit(isReviewExpanded ? nil : 5)
                        
                        HStack {
                            Spacer()
                            Text(isReviewExpanded ? "less" : "more")
                                .foregroundStyle(Color.yellow)
                                .font(.customfont(.semibold, fontSize: 13))
                                .onTapGesture {
                                    withAnimation { isReviewExpanded.toggle() }
                                }
                        }
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "#F4F5F7"))
                    )
                }
                
                // Write a Review button
                HStack {
                    Button(action: {
                        // isReviewPopupOpen = true
                    }) {
                        Image("note")
                            .resizable()
                            .frame(width: geometry.size.width * 0.05, height: geometry.size.width * 0.05)
                        Text("Write a Review")
                            .foregroundStyle(Color.yellow)
                            .font(.customfont(.medium, fontSize: 15))
                    }
                }
            }
        }
    }
}

#Preview {
    Review()
}
