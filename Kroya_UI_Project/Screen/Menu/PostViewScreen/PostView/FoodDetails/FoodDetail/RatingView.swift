//
//  RatingView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/23/24.
//

import SwiftUI

struct RatingView: View {
    @State private var selectedRating: Int = 0
    
    // Dummy data for rating percentages
    let ratingsPercentage: [CGFloat] = [0.9, 0.7, 0.5, 0.3, 0.1] // Example percentages for 5, 4, 3, 2, and 1 stars
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 5) {
                Text("Ratings & Review")
                    .font(.system(size: 17))
                    .bold()
                Spacer().frame(height: geometry.size.height * 0.009)
                HStack {
                    VStack {
                        Text("4.9")
                            .font(.customfont(.bold, fontSize: 34))
                        Text("out of 5")
                            .font(.customfont(.semibold, fontSize: 12))
                    }
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 7) {
                        ForEach(0..<5) { index in
                            HStack(spacing: 15) {
                                HStack(spacing: 2) {
                                    ForEach(0..<(5 - index)) { _ in
                                        Image(systemName: "star.fill")
                                            .font(.customfont(.regular, fontSize: 8))
                                            .foregroundColor(.yellow)
                                    }
                                }
                                
                                ZStack(alignment: .leading) {
                                    RoundedCorner()
                                        .foregroundStyle(Color(hex: "#C7D3EB"))
                                        .frame(width: geometry.size.width * 0.39, height: geometry.size.height * 0.025)
                                    
                                    RoundedCorner()
                                        .foregroundStyle(Color(hex: "#47B2FF"))
                                        .frame(width: geometry.size.width * 0.39 * ratingsPercentage[index], height: geometry.size.height * 0.025)
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Text("168 Ratings")
                        .font(.customfont(.medium, fontSize: 12))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
        }
    }
}

//struct RoundedCorner: Shape {
//    func path(in rect: CGRect) -> Path {
//        let path = RoundedRectangle(cornerRadius: rect.height / 2)
//        return path.path(in: rect)
//    }
//}

#Preview {
    RatingView()
}


