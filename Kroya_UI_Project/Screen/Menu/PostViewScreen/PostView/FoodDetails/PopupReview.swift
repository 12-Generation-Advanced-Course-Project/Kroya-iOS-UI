import SwiftUI
import SDWebImageSwiftUI

struct PopupReview: View {
    @State var description: String = ""
    @State var showWarning = false
    @Binding var isReviewPopupOpen: Bool
    @StateObject private var Profile = ProfileViewModel()
    var urlImagePrefix: String = Constants.fileupload
    @ObservedObject var FeedbackVM: FeedbackViewModel
    @StateObject private var keyboardResponder = KeyboardResponder()
    var ItemType: String
    var FoodId: Int
    @StateObject private var FoodDetailsVM = FoodDetailsViewModel()
    var onFeedbackSubmit: () -> Void
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            ScrollView(.vertical,showsIndicators: false) {
                VStack(alignment: .leading) {
                    // Header Section with Profile
                    HStack(spacing: 10) {
                        if let profileImageUrl = Profile.userProfile?.profileImage, !profileImageUrl.isEmpty {
                            WebImage(url: URL(string: "\(urlImagePrefix)\(profileImageUrl)"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Rectangle())
                                .cornerRadius(10)
                        } else {
                            Image("user-profile") // Placeholder image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(Profile.userProfile?.fullName ?? "Guest")
                                .font(.customfont(.bold, fontSize: 17))
                                .bold()
                            
                            // Star Rating Section
                            HStack(spacing: 2) {
                                ForEach(1..<6) { star in
                                    Image(systemName: star <= FeedbackVM.selectedRating ? "star.fill" : "star")
                                        .font(.system(size: .screenWidth * 0.05))
                                        .foregroundColor(star <= FeedbackVM.selectedRating ? .yellow : .gray)
                                        .onTapGesture {
                                            if !FeedbackVM.isFeedbackLocked {
                                                FeedbackVM.selectedRating = star
                                            } else {
                                                print("Rating already submitted; cannot modify.")
                                            }
                                        }
                                }
                            }
                        }
                    }
                    
                    Spacer().frame(height: 45)
                    
                    // Write a Review Section
                    HStack {
                        Image("note")
                            .resizable()
                            .frame(width: 17, height: 17)
                        Text("Write a Review")
                            .foregroundStyle(Color.yellow)
                            .font(.customfont(.medium, fontSize: 15))
                    }
                    VStack(alignment: .trailing) {
                        VStack {
                            // Review Text Input
                            TextField("Describe your experience", text: $description, axis: .vertical)
                                .textFieldStyle(PlainTextFieldStyle())
                                .multilineTextAlignment(.leading)
                                .padding(10)
                                .frame(maxWidth: .screenWidth * 0.9, minHeight: 220, alignment: .topLeading)
                                .font(.customfont(.medium, fontSize: 15))
                                .foregroundStyle(.black.opacity(0.6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
                                )
                                .onChange(of: description) { _ in
                                    checkCharacterLimit()
                                }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.vertical, 10)
                        
                        // Warning Message and Character Counter
                        HStack {
                            Text(showWarning ? "Maximum character limit of 300 exceeded" : "")
                                .foregroundColor(.red)
                            Spacer()
                            Text("\(description.count)/300")
                                .foregroundColor(.black.opacity(0.3))
                        }
                        .font(.customfont(.medium, fontSize: 12))
                    }
                    
                    Spacer().frame(height: 50)
                    
                    // Action Buttons
                    HStack {
                        // Cancel Button
                        Spacer()
                        Button(action: {
                            withAnimation{
                                isReviewPopupOpen = false
                            }
                        }) {
                            Text("Cancel")
                                .frame(width: 100, height: 45)
                                .font(.customfont(.semibold, fontSize: 16))
                                .background(Color(hex: "#F4F5F7"))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .opacity(0.8)
                        }
                        
                         //Post Button
                        Button(action: {
                            FeedbackVM.commentText = description // Set the comment text
                            FeedbackVM.submitFeedback(itemType: ItemType, foodId: FoodId) { success, message in
                                if success {
                                    print("Feedback submitted successfully!")
                                    isReviewPopupOpen = false
                                    // Fetch the updated food details after feedback submission
                                    onFeedbackSubmit()
                                    FoodDetailsVM.fetchFoodDetails(id: FoodId, itemType: ItemType)
                                } else {
                                    print("Error submitting feedback: \(message)")
                                }
                            }
                            FeedbackVM.getFeedback(
                                itemType: ItemType,
                                foodId: FoodId
                            ) { success, message in
                                if success {
                                    print("Feedback loaded successfully!")
                                    description = FeedbackVM.commentText // Pre-fill the comment text if it exists
                                } else {
                                    print("Error loading feedback: \(message)")
                                }
                            }
                        }) {
                            Text("Post")
                                .frame(width: 100, height: 45)
                                .font(.customfont(.semibold, fontSize: 16))
                                .background(Color.yellow)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
//                        Button(action: {
//                            // Check if feedback is already submitted (rating exists, but comment is empty)
//                            if let existingFeedback = FeedbackVM.feedback,
//                               existingFeedback.ratingValue != nil && existingFeedback.commentText?.isEmpty ?? true {
//                                // Feedback exists with a rating but no comment
//                                print("Rating already provided, you can now add a comment.")
//                            } else if FeedbackVM.isFeedbackLocked {
//                                // If the feedback is locked (both rating and comment are submitted), prevent further modifications
//                                print("Feedback is already submitted, cannot modify.")
//                                showWarning = true  // Show a warning that feedback can't be modified
//                                return
//                            }
//                            
//                            // Check if the user has selected a rating or written a review
//                            guard FeedbackVM.selectedRating > 0 || !description.isEmpty else {
//                                // Show a warning if neither a rating nor a review is provided
//                                showWarning = true
//                                return
//                            }
//                            
//                            // Clear any previous warning if rating or review is provided
//                            showWarning = false
//                            
//                            // Proceed with setting the comment text and submitting feedback
//                            FeedbackVM.commentText = description // Set the comment text
//                            
//                            // Submit feedback based on the current state of rating and comment
//                            FeedbackVM.submitFeedback(itemType: ItemType, foodId: FoodId) { success, message in
//                                if success {
//                                    print("Feedback submitted successfully!")
//                                    isReviewPopupOpen = false
//                                    // Fetch the updated food details after feedback submission
//                                    onFeedbackSubmit()
//                                    FoodDetailsVM.fetchFoodDetails(id: FoodId, itemType: ItemType)
//                                } else {
//                                    print("Error submitting feedback: \(message)")
//                                }
//                            }
//                            
//                            // Fetch the updated feedback to pre-fill the comment text if needed
//                            FeedbackVM.getFeedback(itemType: ItemType, foodId: FoodId) { success, message in
//                                if success {
//                                    print("Feedback loaded successfully!")
//                                    description = FeedbackVM.commentText // Pre-fill the comment text if it exists
//                                } else {
//                                    print("Error loading feedback: \(message)")
//                                }
//                            }
//                        }) {
//                            Text("Post")
//                                .frame(width: 100, height: 45)
//                                .font(.customfont(.semibold, fontSize: 16))
//                                .background(Color.yellow)
//                                .cornerRadius(10)
//                                .foregroundColor(.white)
//                        }


                    }
                }
              
            }
            .frame(maxHeight: .screenHeight * 0.58)
            .simultaneousGesture(
                TapGesture().onEnded {
                    hideKeyboard()
                }
            )
            .padding(.bottom, min(keyboardResponder.currentHeight, 0))
            .padding(30)
            .background(Color.white)
            .cornerRadius(10)
            .padding()
        }
        .onAppear {
            Profile.fetchUserProfile()
            FeedbackVM.getFeedback(
                itemType: ItemType,
                foodId: FoodId
            ) { success, message in
                if success {
                    print("Feedback loaded successfully!")
                    description = FeedbackVM.commentText // Pre-fill the comment text if it exists
                } else {
                    print("Error loading feedback: \(message)")
                }
            }
        }
    }
    
    // MARK: Check Character Limit
    private func checkCharacterLimit() {
        if description.count > 300 {
            description = String(description.prefix(300))
            showWarning = true
        } else if description.count <= 300 {
            showWarning = false
        }
    }
}
