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
    var showPrice: Bool
    @Environment(\.dismiss) var dismiss
    @Binding var isShowPopup: Bool  // Use a binding to control popup
    // @State var isShowPopup  = false
    @State private var isExpanded = false
    @State private var isReviewExpanded = false
    @State private var isReviewPopupOpen : Bool = false
    @State private var description = ""
    // Step details
    let steps = [
        "Cut the fish into bite sized pieces and set aside.",
        "Clean and slice the vegetables.",
        "In a large skillet, heat the curry seed oil, amok paste, shrimp paste, and coconut milk."
        
    ]
    // Dummy data for rating percentages
    let ratingsPercentage: [CGFloat] = [0.9, 0.7, 0.5, 0.3, 0.1]
    
    
    var body: some View {
        GeometryReader { geometry in
            
            let screenHeight = geometry.size.height
            let screenWidth = geometry.size.width
            ScrollView(.vertical, showsIndicators: false){
                VStack (alignment:.leading, spacing: 10){
                    HStack(spacing: 10){
                        // Group{
                        if showPrice {
                            Text("$3.05")
                                .foregroundStyle(Color.yellow)
                                .font(.customfont(.regular, fontSize: 13))
                        }
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
                    
                    
                    // Profile Section
                    Spacer().frame(height: screenHeight * 0.012)
                    NavigationLink(destination: ViewAccount(profileImage: "mehh", userName: "Red Red", email: "redred168@gmail.com")){
                        
                        HStack(spacing: 10) {
                            Image("mehh")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: screenWidth * 0.12, height: screenWidth * 0.12) // Circle image size
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text("Red Red")
                                    .font(.customfont(.bold, fontSize: 17))
                                    .foregroundColor(.black)
                            }
                        }}
                    Spacer().frame(height: screenHeight * 0.003)
                    
                    
                    
                    //  Description
                    Text("Description")
                        .font(.customfont(.bold, fontSize: 18))
                    Text("In the dynamic world of iOS development, harnessing the power of both SwiftUI and UIKit opens up a realm of possibilities. In this tutoria.")
                        .font(.customfont(.regular, fontSize: 14))
                        .multilineTextAlignment(.leading)
                        .lineLimit(5, reservesSpace: true)
                        .opacity(0.6)
                    
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
                    //=========step
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
                                        .frame(width: .screenWidth * 0.06, height: .screenHeight * 0.06)
                                        .overlay(
                                            Image(systemName: "arrow.backward")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: .screenWidth * 0.041, height: .screenHeight * 0.041)
                                                .foregroundColor(Color(hex: "FECC03"))
                                                .clipShape(Circle())
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
                                        .frame(width: .screenWidth * 0.06, height: .screenHeight * 0.06)
                                        .overlay(
                                            Image(systemName: "arrow.right")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: .screenWidth * 0.041, height: .screenHeight * 0.041)
                                                .foregroundColor(Color(hex: "FECC03"))
                                                .clipShape(Circle())
                                        )
                                }.padding(.trailing, 2)
                                
                            }
                        }
                        
                        // TabView for animated step change
                        
                        TabView(selection: $currentStep) {
                            ForEach(1...steps.count, id: \.self) { step in
                                
                                HStack(alignment: .top, spacing: 10) {
                                    Circle()
                                        .fill(Color(hex: "#2E3E5C"))
                                        .frame(width: geometry.size.width * 0.074)
                                        .overlay(
                                            Text("\(step)")
                                                .font(.customfont(.bold, fontSize: 14))
                                                .foregroundColor(Color.white)
                                        )
                                    // Display step detail based on the current step
                                    Text(steps[step - 1])
                                        .font(.system(size: 16))
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(3)
                                    Spacer()
                                }
                                .tag(step) // Tag for each step to track the selected Tab
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never)) // Page style without dots
                        .frame(minHeight: 50, maxHeight: .infinity)
                        .disabled(true)
                        Divider()
                        //Ratings & Review
                        
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
                                                    .font(.customfont(.regular, fontSize: 9))
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
                                    .font(.customfont(.regular, fontSize: 9))
                                    .foregroundColor(.yellow)
                            }
                        }
                        
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
                            isShowPopup = true
                        }) {
                            Image("note")
                                .resizable()
                                .frame(width: .screenWidth * 0.05, height: .screenWidth * 0.05)
                            Text("Write a Review")
                                .foregroundStyle(Color.yellow)
                                .font(.customfont(.medium, fontSize: 15))
                            
                        }.padding(.bottom, 60)
                    }
                    
                }
                
            }
            
        }
    }
}


