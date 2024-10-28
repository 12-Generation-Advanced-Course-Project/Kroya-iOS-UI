//
//  ContentView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isEggChecked = true
    @State private var isButterChecked = true
    @State private var isHalfButterChecked = false
    @State private var isHalfButterChecked1 = false
    @State private var navigateToCheckout = false // State variable to control navigation
    @State private var selectedRating: Int = 0
    @State private var currentStep = 1
    @Environment(\.dismiss) var dismiss
    @State private var isExpanded = false
    @State private var isReviewExpanded = false
    @State private var isReviewPopupOpen = false
   // @State private var selectedRating: Int = 0
    @State private var description = ""
    // Step details
    let steps = [
        "Cut the fish into bite sized pieces and set aside.",
        "Clean and slice the vegetables.",
        "In a large skillet, heat the curry seed oil, amok paste, shrimp paste, and coconut milk. Heat thoroughly, cooking until fragrant.In a large skillet, heat the curry seed oil, amok paste, shrimp paste, and coconut milk. Heat thoroughly, cooking until fragrant.In a large skillet, heat the curry seed oil, amok paste, shrimp paste, and coconut milk. Heat thoroughly, cooking until fragrant.In a large skillet, heat the curry seed oil, amok paste, shrimp paste, and coconut milk. Heat thoroughly, cooking until fragrant."
    
    ]
    // Dummy data for rating percentages
    let ratingsPercentage: [CGFloat] = [0.9, 0.7, 0.5, 0.3, 0.1] // Example percentages for 5, 4, 3, 2, and 1 stars
    
    
    var body: some View {
        GeometryReader { geometry in
            
            let screenHeight = geometry.size.height
            let screenWidth = geometry.size.width
        
                VStack (alignment:.leading, spacing: 10){
//                    HStack{
//                        Text("Somlor Mju")
//                            .font(.customfont(.bold, fontSize: 20))
//                        Spacer()
//                        
//                        // Button Order
//                        
//                        Button(action : {
//                            // navigateToCheckout = true // Set to true to trigger navigation
//                        })
//                        {
//                            HStack {
//                                Text("Order")
//                                    .font(.customfont(.medium, fontSize: 16))
//                                    .foregroundStyle(.white)
//                                Image(systemName: "plus")
//                                    .resizable()
//                                    .frame(width: 14, height: 14)
//                                    .foregroundStyle(Color.white)
//                            }
//                            .frame(width: .screenWidth * 0.25, height: .screenHeight * 0.04)
//                            .background(PrimaryColor.normal)
//                            .cornerRadius(.screenWidth * 0.022)
//                        }
//                        
//                    }
                    
                    HStack(spacing: 10){
                        // Group{
                        Text("$3.05")
                            .foregroundStyle(Color.yellow)
                            .font(.customfont(.regular, fontSize: 13))
                        Text("5 May 2023 (Morning)")
                            .opacity(0.5)
                        
                            .font(.customfont(.regular, fontSize: 13))
                        
                    }
                    
                    
                    HStack(spacing: 10){
                        Text("Soup")
                        Circle().fill()
                            .frame(width: 6, height: 6)
                        Text("60 mins")
                        
                    }.font(.customfont(.medium, fontSize: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(Color(hex:"#9FA5C0"))
                    
                    // Profile
                    
                    // Profile Section
                    Spacer().frame(height: screenHeight * 0.012)
                    HStack(spacing: 10) {
                        Image("mehh")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: screenWidth * 0.12, height: screenWidth * 0.12) // Circle image size
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text("PSN Team")
                                .font(.customfont(.bold, fontSize: 17))
                                .foregroundColor(.black)
                        }
                    }
                    Spacer().frame(height: screenHeight * 0.008)
                    
                    
                    
                    //  Description
                    Text("Description")
                        .font(.customfont(.bold, fontSize: 18))
                    Text("In the dynamic world of iOS development, harnessing the power of both SwiftUI and UIKit opens up a realm of possibilities. In this tutorial, we’ll delve into the seamless integration of UIKit’s UITableView in SwiftUI, exploring step-by-step how to create project.In the dynamic world of iOS development, harnessing the power of both SwiftUI and UIKit opens up a realm of possibilities. In this tutorial, we’ll delve into the seamless integration of UIKit’s UITableView in SwiftUI, exploring step-by-step how to create project.")
                        .font(.customfont(.regular, fontSize: 14))
                        .multilineTextAlignment(.leading)
                        .lineLimit(10, reservesSpace: true)
                        .opacity(0.6)
                    // Spacer().frame(height: .screenHeight * 0.008)
                    //Ingredients
                    Text("Ingredients")
                        .font(.customfont(.bold, fontSize: 18))
                    
                    // Egg Ingredient
                    HStack {
                        Button(action: {
                            isEggChecked.toggle()
                        }) {
                            Circle()
                                .fill(isEggChecked ? Color.green.opacity(0.2) : Color.clear)
                                .frame(width: geometry.size.width * 0.07, height: geometry.size.width * 0.07)
                                .overlay(
                                    Circle()
                                        .stroke(isEggChecked ? Color.clear : Color.gray, lineWidth: 1)
                                )
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .foregroundColor(isEggChecked ? .green : .clear)
                                )
                        }
                        Text("4 Eggs")
                            .font(.customfont(.regular, fontSize: 17))
                            .foregroundColor(Color(hex: "#2E3E5C"))
                    }
                    
                    // Half Butter Ingredient
                    HStack {
                        Button(action: {
                            isButterChecked.toggle()
                        }) {
                            Circle()
                                .fill(isButterChecked ? Color.green.opacity(0.2) : Color.clear)
                                .frame(width: geometry.size.width * 0.07, height: geometry.size.width * 0.07)
                                .overlay(
                                    Circle()
                                        .stroke(isButterChecked ? Color.clear : Color.gray, lineWidth: 1)
                                )
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .foregroundColor(isButterChecked ? .green : .clear)
                                )
                        }
                        Text("1/2 Butter")
                            .font(.customfont(.regular, fontSize: 17))
                            .foregroundColor(Color(hex: "#2E3E5C"))
                    }
                    Divider()
                    ////=========step
                    VStack(alignment: .leading, spacing: 10) {
                        // Title and Navigation Buttons
                        HStack {
                            Text("Steps")
                                .font(.system(size: 17))
                                .bold()
                            
                            Spacer()
                            
                            // Navigation buttons
                            HStack(spacing: 10) {
                                Button(action: {
                                    if currentStep > 1 {
                                        withAnimation(.easeInOut) {
                                            currentStep -= 1
                                        }
                                    }
                                }) {
                                    Circle()
                                        .stroke(Color(hex: "FECC03"), lineWidth: 2)
                                        .frame(width: screenWidth * 0.06, height: screenWidth * 0.06)
                                        .overlay(
                                            Image(systemName: "arrow.backward")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: screenWidth * 0.04, height: screenHeight * 0.04)
                                                .foregroundColor(Color(hex: "FECC03"))
                                        )
                                }
                                
                                Button(action: {
                                    if currentStep < steps.count {
                                        withAnimation(.easeInOut) {
                                            currentStep += 1
                                        }
                                    }
                                }) {
                                    Circle()
                                        .stroke(Color(hex: "FECC03"), lineWidth: 2)
                                        .frame(width: screenWidth * 0.06, height: screenWidth * 0.06)
                                        .overlay(
                                            Image(systemName: "arrow.right")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: screenWidth * 0.04, height: screenHeight * 0.04)
                                                .foregroundColor(Color(hex: "FECC03"))
                                        )
                                }
                            }
                        }
                        
                        // Step Content
                        HStack(alignment: .top, spacing: 10) {
                            Circle()
                                .fill(Color(hex: "#2E3E5C"))
                                .frame(width: screenWidth * 0.06, height: screenWidth * 0.06)
                                .overlay(
                                    Text("\(currentStep)")
                                        .font(.customfont(.bold, fontSize: 14))
                                        .foregroundColor(.white)
                                )
                            
                            // Display current step detail
                            Text(steps[currentStep - 1])
                                .font(.system(size: 16))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                       // .padding(.top, 10)
                        Divider()
                        
                        ///=====
                        
                        Text("Ratings & Review")
                            .font(.system(size: 17))
                            .bold()
                        Spacer().frame(height: .screenHeight * 0.003)
                        HStack {
                            VStack {
                                Text("4.9")
                                    .font(.customfont(.bold, fontSize: 34))
                                Text("out of 5")
                                    .font(.customfont(.semibold, fontSize: 12))
                            }
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 5) {
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
                                                .frame(width: .screenWidth * 0.4, height: .screenHeight * 0.0035)
                                            
                                            RoundedCorner()
                                                .foregroundStyle(Color(hex: "#47B2FF"))
                                                .frame(width: .screenWidth * 0.4 * ratingsPercentage[index], height: .screenHeight * 0.0035)
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
                        }}
            Divider()
 ///=====
                    // User review
                    HStack {
                        Text("Tap to Rate")
                            .font(.customfont(.regular, fontSize: 18))
                            .foregroundStyle(Color.gray)
                        Spacer()
                        HStack(spacing: 2) {
                            ForEach(1..<6) { star in
                                Image(systemName: selectedRating >= star ? "star.fill" : "star")
                                    .font(.system(size: .screenWidth * 0.05))
                                    .foregroundColor(selectedRating >= star ? .yellow : .gray)
                                    .onTapGesture {
                                        selectedRating = (selectedRating == star) ? 0 : star
                                    }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: .screenHeight * 0.007) {
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
                        
                        //Spacer().frame(height: .screenHeight * 0.004)
                        
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
                                .frame(width: .screenWidth * 0.05, height: .screenWidth * 0.05)
                            Text("Write a Review")
                                .foregroundStyle(Color.yellow)
                                .font(.customfont(.medium, fontSize: 15))
                        }
                    }
                    //
                    
                    
                    //===================
                }
        }
 
    }
}

#Preview {
    ContentView()
}
