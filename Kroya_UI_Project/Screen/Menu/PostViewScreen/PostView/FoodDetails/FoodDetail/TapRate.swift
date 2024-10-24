//
//  TapRate.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/23/24.
//

import SwiftUI

struct TapRate: View {
    @State private var selectedRating : Int = 0
    
    var body: some View {
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
                    }}}}
        
    }
}

#Preview {
    TapRate()
}
