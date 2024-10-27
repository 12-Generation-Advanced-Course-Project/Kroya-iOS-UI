//
//  Review.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/23/24.
//

import SwiftUI

struct Review: View {
    @State private var isExpanded = false
    @State private var isReviewExpanded = false
    @State private var selectedRating : Int = 0
    var body: some View {
        
        // User review section
        GeometryReader { geometry in
            VStack (alignment:.leading, spacing: 10){
                //     User review
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
                                    // If user taps the same rating again, clear the rating (set to 0)
                                    if selectedRating == star {
                                        selectedRating = 0 // Allow user to clear the rating entirely
                                    } else {
                                        selectedRating = star // Set the selected rating
                                    }
                                    print("User rated: \(selectedRating) stars") // Example log
                                }
                        }
                    }}
                
                VStack(alignment: .leading, spacing: geometry.size.height * 0.007) {
                    Text("You cabn do it!")
                        .font(.customfont(.semibold, fontSize: 14))
                    
                    // Star rating for the user's review
                    HStack(spacing: 2) {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill")
                                .font(.customfont(.regular, fontSize: 10))
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    Spacer().frame(height: geometry.size.height * 0.001)
                    Text("Your recipe has been uploaded, you can see it on your profile. Your recipe has beeyour. Your recipe has been uploaded, you can see it on yourn uploaded, you can see it on your. Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your. Your recipe has been uploaded, you see it on your profile. Your recipe has been uploaded, you can see it on your. Your recipe has been uploaded, you")
                        .font(.customfont(.regular, fontSize: 14))
                        .foregroundStyle(Color(hex: "#2E3E5C"))
                        .lineLimit(isReviewExpanded ? nil : 5) // Limit to 5 lines when collapsed
                    
                    //                    HStack{
                    //                        Spacer()
                    Text(isReviewExpanded ? "less" : "more")
                        .foregroundStyle(Color.yellow)
                        .font(.customfont(.semibold, fontSize: 13))
                        .onTapGesture {
                            withAnimation {
                                isReviewExpanded.toggle() // Toggle the state when "more" or "less" is clicked
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hex: "#F4F5F7"))
                        )
                }
            // }
                
                
                
                // Review detail with "more" functionality
       //                                        Text(reviewDetail)
       //                                            .font(.customfont(.regular, fontSize: 13))
       //                                            .foregroundStyle(Color(hex: "#2E3E5C"))
       //                                            .lineLimit(isReviewExpanded ? nil : 5) // Limit to 5 lines when collapsed
       //                                        //  +
       //                                        Text(isReviewExpanded ? "less" : "more")
       //                                            .foregroundStyle(Color.yellow)
       //                                            .font(.customfont(.semibold, fontSize: 13))
       //                                            .onTapGesture {
       //                                                withAnimation {
       //                                                    isReviewExpanded.toggle() // Toggle the state when "more" or "less" is clicked
       //                                                }
       //                                            }
       //                                    }
       //                                    //                            .padding(.vertical, 10)
       //                                    //                            .padding(.horizontal, 13)
       //                                    .background(
       //                                        RoundedRectangle(cornerRadius: 10)
       //                                            .fill(Color(hex: "#F4F5F7"))
                
                
                // Write a Review
                HStack{
                    Button(action: {
                        // isReviewPopupOpen = true
                    }){
                        
                        Image("note")
                            .resizable()
                            .frame(width: geometry.size.width * 0.05, height: geometry.size.width * 0.05)
                       
                    }
                    Text("Write a Review").foregroundStyle(Color.yellow)
                        .font(.customfont(.medium, fontSize: 15))
                       // .frame(width: .infinity)
                }
                
                
                
            }
        }
    }
}

#Preview {
    Review()
}
