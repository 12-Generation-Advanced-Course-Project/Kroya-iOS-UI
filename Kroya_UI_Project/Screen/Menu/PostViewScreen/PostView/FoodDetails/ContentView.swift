//
//  ContentView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/28/24.
//

import SwiftUI
import SDWebImageSwiftUI
struct ContentView: View {
    @State private var isEggChecked = true
    @State private var isButterChecked = true
    @State private var isHalfButterChecked = false
    @State private var isHalfButterChecked1 = false
    @State private var navigateToCheckout = false
    @State private var selectedRating: Int = 0
    @State private var currentStep = 1
    var showPrice: Bool
    @Environment(\.dismiss) var dismiss
    @Binding var isShowPopup: Bool
    // @State var isShowPopup  = false
    @State private var isExpanded = false
    @State private var isReviewExpanded = false
    @State private var isReviewPopupOpen : Bool = false
    @State private var descriptionText: String = ""
    @State private var isDescriptionExpanded = false
    var itemType: String
    var FoodId:Int
    @ObservedObject var FoodDetails: FoodDetailsViewModel
    @StateObject private var FeedbackVM = FeedbackViewModel()
    @StateObject private  var Profile =  ProfileViewModel()
    // Dummy data for rating percentages
    let ratingsPercentage: [CGFloat] = [0.9, 0.7, 0.5, 0.3, 0.1]
    // MARK: Timer Logic
    @State private var isPendingSubmission = false
    @State private var remainingTime = 10
    @State private var autoSubmitTimer: Timer?
    @State private var refreshID = UUID()
    @State private var checkedIngredients: [Int: Bool] = [:]
    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            let screenWidth = geometry.size.width
            ScrollView(.vertical, showsIndicators: false){
                VStack (alignment:.leading, spacing: 10){
                    HStack(spacing: 10) {
                        if showPrice || itemType == "FOOD_SELL" {
                            if let foodSellDetails = FoodDetails.foodSellDetail {
                                HStack(spacing: 2) {
                                    Text("\(currencySymbol(for: foodSellDetails.currencyType))")
                                        .foregroundStyle(Color.yellow)
                                        .font(.customfont(.bold, fontSize: 16)) // Bigger font size for the currency symbol
                                    Text("\(foodSellDetails.price, specifier: "%.2f")")
                                        .foregroundStyle(Color.yellow)
                                        .font(.customfont(.bold, fontSize: 14)) // Regular size for the price
                                }
                            }
                        }
                        
                        HStack(spacing: 10) {
                            if let cookingDate = FoodDetails.foodSellDetail?.dateCooking ?? FoodDetails.foodSellDetail?.dateCooking {
                                Text("\(formatDate(cookingDate)) \(determineTimeOfDay(from: cookingDate))")
                                    .opacity(0.5)
                                    .font(.customfont(.bold, fontSize: 14))
                                    .foregroundStyle(.black.opacity(0.6))
                            }
                        }
                    }
                    HStack(spacing: 10) {
                        if itemType == "FOOD_RECIPE" {
                            if let cuisineName = FoodDetails.foodRecipeDetail?.cuisineName {
                                Text(cuisineName)
                            }
                            Circle()
                                .fill()
                                .frame(width: 6, height: 6)
                            if let duration = FoodDetails.foodRecipeDetail?.durationInMinutes {
                                Text("\(duration) mins")
                            }
                        } else if itemType == "FOOD_SELL" {
                            if let cuisineName = FoodDetails.foodSellDetail?.foodRecipeDTO.cuisineName {
                                Text(cuisineName)
                            }
                            Circle()
                                .fill()
                                .frame(width: 6, height: 6)
                            if let duration = FoodDetails.foodSellDetail?.foodRecipeDTO.durationInMinutes {
                                Text("\(duration) mins")
                            }
                        }
                    }
                    .font(.customfont(.medium, fontSize: 16))
                    .fontWeight(.medium)
                    .foregroundStyle(Color(hex: "#9FA5C0"))
                    
                    //MARK:  Profile Section
                    Spacer().frame(height: screenHeight * 0.012)
                    NavigationLink(
                        destination: ViewAccount(
                            userId: FoodDetails.foodRecipeDetail?.user.id ?? FoodDetails.foodSellDetail?.foodRecipeDTO.user.id ?? 0
                        )
                    ) {
                        HStack(spacing: 10) {
                            // Profile Image
                            if let profileImageURL = FoodDetails.foodRecipeDetail?.user.profileImage ?? FoodDetails.foodSellDetail?.foodRecipeDTO.user.profileImage,
                               let url = URL(string: "https://kroya-api-production.up.railway.app/api/v1/fileView/\(profileImageURL)") {
                                WebImage(url: url)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: screenWidth * 0.12, height: screenWidth * 0.12)
                                    .clipShape(Circle())
                            } else {
                                Image("user")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: screenWidth * 0.12, height: screenWidth * 0.12)
                                    .clipShape(Circle())
                            }
                            
                            // Profile Name
                            Text(FoodDetails.foodRecipeDetail?.user.fullName ?? FoodDetails.foodSellDetail?.foodRecipeDTO.user.fullName ?? "Unknown")
                                .font(.customfont(.bold, fontSize: 17))
                                .foregroundColor(.black)
                        }
                    }
                    
                    
                    Spacer().frame(height: screenHeight * 0.003)
                    // Description Section
                    if let description = FoodDetails.foodRecipeDetail?.description ?? FoodDetails.foodSellDetail?.foodRecipeDTO.description {
                        Text("Description")
                            .font(.customfont(.bold, fontSize: 18))
                        VStack(alignment: .leading, spacing: 5) {
                            Text(descriptionText.isEmpty ? description : descriptionText)
                                .font(.customfont(.regular, fontSize: 14))
                                .multilineTextAlignment(.leading)
                                .lineLimit(isDescriptionExpanded ? nil : 5)
                                .opacity(0.6)
                            
                            Text(isDescriptionExpanded ? "Show Less" : "Show More")
                                .font(.customfont(.semibold, fontSize: 13))
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    withAnimation {
                                        isDescriptionExpanded.toggle()
                                    }
                                }
                        }
                        .onAppear {
                            descriptionText = description
                        }
                    }
                    
                    //MARK: Ingredients Section
                    if let ingredients = FoodDetails.foodRecipeDetail?.ingredients ?? FoodDetails.foodSellDetail?.foodRecipeDTO.ingredients, !ingredients.isEmpty {
                        Text("Ingredients")
                            .font(.customfont(.bold, fontSize: 18))
                            .padding(.bottom, 10)
                        
                        ForEach(ingredients, id: \.id) { ingredient in
                            HStack(alignment: .top, spacing: 10) {
                                // Checkmark Button
                                Button(action: {
                                    // Toggle the checked state for this ingredient's ID
                                    checkedIngredients[ingredient.id ?? 0, default: false].toggle()
                                }) {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: geometry.size.width * 0.07, height: geometry.size.width * 0.07)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.clear, lineWidth: 1)
                                        )
                                        .overlay(
                                            Image(systemName: checkedIngredients[ingredient.id ?? 0, default: false] ? "checkmark.circle.fill" : "checkmark.circle")
                                                .foregroundColor(checkedIngredients[ingredient.id ?? 0, default: false] ? .green : .gray)
                                        )
                                }
                                
                                // Ingredient Text
                                Text("\(ingredient.quantity, specifier: "%.0f") \(ingredient.name)")
                                    .font(.customfont(.regular, fontSize: 17))
                                    .foregroundColor(Color(hex: "#2E3E5C"))
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        // MARK: Steps Section
                        if let steps = FoodDetails.foodRecipeDetail?.cookingSteps ?? FoodDetails.foodSellDetail?.foodRecipeDTO.cookingSteps, !steps.isEmpty {
                            // Title and Navigation Buttons
                            HStack {
                                Text("Steps")
                                    .font(.customfont(.bold, fontSize: 20))
                                Spacer()
                                HStack(spacing: 10) {
                                    // Backward Button
                                    Button(action: {
                                        if currentStep > 1 {
                                            withAnimation(.easeInOut) {
                                                currentStep -= 1
                                                isExpanded = false // Collapse when changing steps
                                            }
                                        }
                                    }) {
                                        Circle()
                                            .stroke(currentStep <= 1 ? .gray.opacity(0.8) : .yellow, lineWidth: 2)
                                            .frame(width: 28, height: 28)
                                            .overlay(
                                                Image(systemName: "arrow.backward")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(currentStep <= 1 ? .gray.opacity(0.8) : .yellow)
                                            )
                                    }
                                    .disabled(currentStep <= 1)
                                    
                                    // Forward Button
                                    Button(action: {
                                        if currentStep < steps.count {
                                            withAnimation(.easeInOut) {
                                                currentStep += 1
                                                isExpanded = false // Collapse when changing steps
                                            }
                                        }
                                    }) {
                                        Circle()
                                            .stroke(currentStep >= steps.count ? .gray.opacity(0.8) : .yellow, lineWidth: 2)
                                            .frame(width: 28, height: 28)
                                            .overlay(
                                                Image(systemName: "arrow.right")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(currentStep >= steps.count ? .gray.opacity(0.8) : .yellow)
                                            )
                                    }
                                    .disabled(currentStep >= steps.count)
                                }
                            }
                            .padding(.vertical, 10)
                            
                            // Step Details
                            VStack(alignment: .leading, spacing: 10) {
                                if currentStep > 0 && currentStep <= steps.count {
                                    HStack(alignment: .top, spacing: 8) {
                                        // Step Number
                                        ZStack {
                                            Circle()
                                                .fill(Color(hex: "2D3E50")) // Dark color for the circle
                                                .frame(width: 24, height: 24)
                                            Text("\(currentStep)")
                                                .font(.system(size: 14))
                                                .foregroundColor(.white)
                                        }
                                        
                                        // Step Description
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(steps[currentStep - 1].description)
                                                .font(.system(size: 14))
                                                .foregroundColor(Color(hex: "#2E3E5C"))
                                                .lineLimit(isExpanded ? nil : 3)
                                                .truncationMode(.tail)
                                                .transition(.slide)
                                                .animation(.easeInOut(duration: 0.3), value: currentStep)
                                            
                                            // Expand/Collapse Button
                                            if steps[currentStep - 1].description.count > 100 {
                                                Text(isExpanded ? "Show Less" : "Show More")
                                                    .font(.customfont(.semibold, fontSize: 13))
                                                    .foregroundColor(.yellow)
                                                    .onTapGesture {
                                                        withAnimation {
                                                            isExpanded.toggle()
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                    .padding(.vertical, 10)
                                }
                            }
                        }

                        
                        //MARK: Ratings & Review
                        Text("Ratings & Review")
                            .font(.system(size: 17))
                            .bold()
                        Spacer().frame(height: .screenHeight * 0.003)
                        
                        HStack {
                            // Average Rating
                            VStack {
                                Text(String(format: "%.1f", FoodDetails.foodRecipeDetail?.averageRating
                                            ?? FoodDetails.foodSellDetail?.foodRecipeDTO.averageRating ?? 0.0))
                                .font(.customfont(.bold, fontSize: 34))
                                Text("out of 5")
                                    .font(.customfont(.semibold, fontSize: 12))
                            }
                            Spacer()
                            
                            // Rating Percentages
                            VStack(alignment: .trailing, spacing: 5) {
                                ForEach((1...5).reversed(), id: \.self) { index in
                                    HStack(spacing: 15) {
                                        // Stars Section
                                        HStack(spacing: 2) {
                                            ForEach(0..<index, id: \.self) { _ in
                                                Image(systemName: "star.fill")
                                                    .font(.customfont(.regular, fontSize: 9))
                                                    .foregroundColor(.yellow)
                                            }
                                        }
                                        
                                        // Rating Bar Section
                                        ZStack(alignment: .leading) {
                                            RoundedCorner()
                                                .foregroundStyle(Color(hex: "#C7D3EB"))
                                                .frame(width: .screenWidth * 0.4, height: .screenHeight * 0.0035)
                                            
                                            if let ratingPercentages = FoodDetails.foodRecipeDetail?.ratingPercentages?.toDictionary()
                                                ?? FoodDetails.foodSellDetail?.ratingPercentages?.toDictionary(),
                                               let percentage = ratingPercentages["\(index)"] {
                                                RoundedCorner()
                                                    .foregroundStyle(Color(hex: "#47B2FF"))
                                                    .frame(width: .screenWidth * 0.4 * CGFloat(percentage / 100), height: .screenHeight * 0.0035)
                                            } else {
                                                RoundedCorner()
                                                    .foregroundStyle(Color.clear) // Show empty bar if no data
                                                    .frame(width: .screenWidth * 0.4, height: .screenHeight * 0.0035)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Total Raters
                        HStack {
                            Spacer()
                            Text("\((FoodDetails.foodRecipeDetail?.totalRaters ?? FoodDetails.foodSellDetail?.foodRecipeDTO.totalRaters) ?? 0) Ratings") // Fallback to "0 Ratings" if nil
                                .font(.customfont(.medium, fontSize: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    Divider()
                    let foodOwnerID = FoodDetails.foodRecipeDetail?.user.id ?? FoodDetails.foodSellDetail?.foodRecipeDTO.user.id ?? 0
                    // MARK: User Review Section
                    if Profile.userProfile?.id != foodOwnerID {
                        HStack {
                            Text("Tap to Rate")
                                .font(.customfont(.regular, fontSize: 18))
                                .foregroundStyle(.gray.opacity(0.8))
                                .id(refreshID)
                            Spacer()
                            HStack(spacing: 2) {
                                ForEach(1..<6) { star in
                                    Image(systemName: star <= FeedbackVM.selectedRating ? "star.fill" : "star")
                                        .font(.system(size: .screenWidth * 0.05))
                                        .foregroundColor(star <= FeedbackVM.selectedRating ? .yellow : .gray)
                                        .onTapGesture {
                                            if !FeedbackVM.isFeedbackLocked {
                                                FeedbackVM.selectedRating = star
                                                cancelAutoSubmitTimer()
                                                startAutoSubmitTimer()
                                            } else {
                                                print("Rating already submitted; cannot modify.")
                                            }
                                        }
                                }
                            }
                        }
                    }
                    // MARK: Show all Rating Star and Comment
                    VStack(alignment: .leading, spacing: .screenHeight * 0.007) {
                        if !FeedbackVM.getAllUserFeedback.isEmpty {
                            Text("All Feedback")
                                .font(.customfont(.semibold, fontSize: 14))
                            
                            ForEach(FeedbackVM.getAllUserFeedback, id: \.feedbackId) { feedback in
                                VStack(alignment: .leading, spacing: 10) {
                                    // User Name
                                    Text(feedback.user.fullName)
                                        .font(.customfont(.semibold, fontSize: 14))
                                    
                                    // Star Rating
                                    HStack(spacing: 2) {
                                        ForEach(0..<5) { index in
                                            Image(systemName: index < (feedback.ratingValue ?? 0) ? "star.fill" : "star")
                                                .font(.customfont(.regular, fontSize: 9))
                                                .foregroundColor(index < (feedback.ratingValue ?? 0) ? .yellow : .gray)
                                        }
                                    }
                                    
                                    // User Comment (if available)
                                    if let commentText = feedback.commentText, !commentText.isEmpty {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(commentText)
                                                .font(.customfont(.regular, fontSize: 14))
                                                .foregroundStyle(Color(hex: "#2E3E5C"))
                                                .lineLimit(isReviewExpanded ? nil : 5)
                                                .multilineTextAlignment(.leading)
                                            
                                            // Expand/Collapse Button
                                            HStack {
                                                Spacer()
                                                if commentText.count > 100 {
                                                    Text(isReviewExpanded ? "less" : "more")
                                                        .foregroundStyle(Color.yellow)
                                                        .font(.customfont(.semibold, fontSize: 13))
                                                        .onTapGesture {
                                                            withAnimation { isReviewExpanded.toggle() }
                                                        }
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(10)
                                .frame(maxWidth:.infinity,alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: "#F4F5F7"))
                                )
                                .padding(.vertical, 5) // Space between each user's feedback
                            }
                        } else {
                            // Placeholder text for no feedback
                            Text("No feedback yet")
                                .font(.customfont(.regular, fontSize: 14))
                                .foregroundColor(Color.gray)
                        }
                    }

                    // MARK: Write a Review button
                    if Profile.userProfile?.id != foodOwnerID {
                        HStack {
                            Button(action: {
                                if FeedbackVM.commentText.isEmpty || !FeedbackVM.isFeedbackLocked {
                                    // Allow submitting a comment if no comment exists OR rating is not locked
                                    withAnimation(.easeInOut) {
                                        isShowPopup = true // Show the popup
                                    }
                                } else {
                                    print("Cannot rate or review again.")
                                }
                            }) {
                                Image("note")
                                    .resizable()
                                    .frame(width: .screenWidth * 0.05, height: .screenWidth * 0.05)
                                Text("Write a Review")
                                    .foregroundStyle(Color.yellow)
                                    .font(.customfont(.medium, fontSize: 15))
                            }
                            .disabled(FeedbackVM.isFeedbackLocked && !FeedbackVM.commentText.isEmpty)
                            .padding(.bottom, 50)
                            
                        }
                    }
                }
                
            }
        }
        .onAppear {
            FeedbackVM.fetchAllFeedback(itemType: itemType, foodId: FoodId) { success, message in
                   if success {
                       print("All feedback loaded successfully!")
                   } else {
                       print("Error loading all feedback: \(message)")
                   }
               }
            Profile.fetchUserProfile()
            // Fetch initial feedback when ContentView appears
            FeedbackVM.getFeedback(
                itemType: itemType,
                foodId: FoodId
            ) { success, message in
                if success {
                    print("Feedback loaded successfully!")
                    refreshID = UUID() // Trigger UI refresh
                } else {
                    print("Error loading feedback: \(message)")
                    // Reset placeholders if no feedback found
                    FeedbackVM.selectedRating = 0
                    FeedbackVM.commentText = ""
                }
            }
        }
        .animation(.easeInOut, value: FeedbackVM.selectedRating)
    }
    
    
    //MARK: Helper function to get the currency symbol
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

    
    private func startAutoSubmitTimer() {
        guard !FeedbackVM.isFeedbackLocked else {
            print("Feedback already locked; cannot submit.")
            return
        }
        
        isPendingSubmission = true
        remainingTime = 5
        
        autoSubmitTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if remainingTime > 1 {
                remainingTime -= 1
            } else {
                timer.invalidate()
                autoSubmitTimer = nil
                isPendingSubmission = false
                
                // Submit the rating
                FeedbackVM.submitRating(
                    itemType: FoodDetails.foodRecipeDetail?.itemType ?? FoodDetails.foodSellDetail?.itemType ?? "",
                    foodId: FoodDetails.foodSellDetail?.id ?? FoodDetails.foodRecipeDetail?.id ?? 0
                ) { success, message in
                    print(message) // Handle success or error message
                    
                    if success {
                        // Fetch the latest feedback
                        FeedbackVM.getFeedback(
                            itemType: itemType,
                            foodId: FoodDetails.foodSellDetail?.id ?? FoodDetails.foodRecipeDetail?.id ?? 0
                        ) { success, message in
                            if success {
                                print("Feedback loaded successfully!")
                                refreshID = UUID() // Trigger UI refresh
                            } else {
                                print("Error loading feedback: \(message)")
                                // Reset placeholders if no feedback found
                                FeedbackVM.selectedRating = 0
                                FeedbackVM.commentText = ""
                            }
                        }
                    }
                }
            }
        }
    }

    
    private func cancelAutoSubmitTimer() {
        autoSubmitTimer?.invalidate()
        autoSubmitTimer = nil
        isPendingSubmission = false
    }
    
    
}


