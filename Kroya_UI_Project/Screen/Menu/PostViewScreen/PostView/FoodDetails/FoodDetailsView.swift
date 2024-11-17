import SwiftUI
import SDWebImageSwiftUI

struct FoodDetailView: View {
    @State private var isFavorite: Bool = false
    @State private var currentImage: String = ""
    @State private var isBottomSheetOpen: Bool = false
    @State private var isShowPopup: Bool = false
    @StateObject private var FoodDetailsVM = FoodDetailsViewModel()
    @StateObject private var FeedbackVM = FeedbackViewModel()
   
    var showPrice: Bool
    var showOrderButton: Bool
    var showButtonInvoic: Bool?
    var invoiceAccept: Bool?
    var notificationType: Int?
    var FoodId: Int
    var ItemType: String
    @State private var refreshID = UUID()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            let screenWidth = geometry.size.width
            
            ZStack {
                VStack {
                    if !currentImage.isEmpty, let mainImageURL = URL(string: currentImage) {
                        WebImage(url: mainImageURL)
                            .resizable()
                            .scaledToFill()
                            .frame(width: screenWidth, height: screenHeight * 0.4)
                            .clipped()
                            .edgesIgnoringSafeArea(.top)
                            .overlay {
                                HStack {
                                    Button(action: { dismiss() }) {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: screenWidth * 0.07, height: screenHeight * 0.07)
                                            .overlay(
                                                Image(systemName: "arrow.left")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 17))
                                            )
                                    }
                                    Spacer()
                                    Button(action: { isFavorite.toggle() }) {
                                        Circle()
                                            .fill(isFavorite ? Color(hex: "#FE724C") : Color.white.opacity(0.5))
                                            .frame(width: screenWidth * 0.07, height: screenHeight * 0.07)
                                            .overlay(
                                                Image(systemName: "heart.fill")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 18))
                                            )
                                    }
                                    .shadow(color: isFavorite ? Color.red.opacity(0.5) : Color.gray.opacity(0.5), radius: 4, x: 0, y: 4)
                                }
                                .padding(.horizontal, screenWidth * 0.045)
                                .offset(y: -screenHeight * 0.18)
                            }
                            .overlay(
                                thumbnailsOverlay
                                    .offset(y: .screenHeight * 0.05)
                            )
                        
                    } else {
                        ProgressView()
                            .frame(height: screenHeight * 0.4)
                            .edgesIgnoringSafeArea(.top)
                    }
                    Spacer()
                }
                
                // Bottom Sheet Content
                BottomSheetView(isOpen: $isBottomSheetOpen, maxHeight: .screenHeight * 1, minHeight: .screenHeight * 0.67, showOrderButton: showOrderButton, notificationType: notificationType, showButtonInvoic: showButtonInvoic ?? false, invoiceAccept: invoiceAccept ?? false,itemType: ItemType, FoodDetails: FoodDetailsVM)
                {
                    ContentView(showPrice: showPrice, isShowPopup: $isShowPopup,itemType: ItemType, FoodId: FoodId, FoodDetails: FoodDetailsVM)
                        .padding(.horizontal, 10)
                    
                }
                .edgesIgnoringSafeArea(.all)
                
                if isShowPopup {
                    PopupReview(isReviewPopupOpen: $isShowPopup, FeedbackVM: FeedbackVM, ItemType: ItemType, FoodId: FoodId)
                        .background(Color.black.opacity(0.5))
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .onAppear {
                // Fetch the food details
                FoodDetailsVM.fetchFoodDetails(id: FoodId, itemType: ItemType)
                if ItemType == "FOOD_RECIPE" {
                    observeRecipeDetails()
                } else if ItemType == "FOOD_SELL" {
                    observeSellDetails()
                }

                // Fetch the feedback
                FeedbackVM.getFeedback(
                    itemType: ItemType,
                    foodId: FoodId
                ) { success, message in
                    if success {
                        print("Feedback loaded successfully!")
                        print("Selected Rating: \(FeedbackVM.selectedRating)")
                        refreshID = UUID()
                    } else {
                        print("Error loading feedback: \(message)")
                    }
                }
            }
            .onChange(of: FeedbackVM.selectedRating) { newRating in
                print("UI should reflect new rating: \(newRating)")
            }

            .navigationBarBackButtonHidden(true)
        }
    }
    
    // MARK: Observe Recipe Details
    private func observeRecipeDetails() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let recipeDetail = FoodDetailsVM.foodRecipeDetail {
                setImages(from: recipeDetail.photo)
            } else {
                observeRecipeDetails()
            }
        }
    }
    
    // MARK: Observe Sell Details
    private func observeSellDetails() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let sellDetail = FoodDetailsVM.foodSellDetail {
                setImages(from: sellDetail.foodRecipeDTO.photo)
            } else {
                observeSellDetails()
            }
        }
    }
    
    // MARK: Set Current and Thumbnail Images
    private func setImages(from photos: [Photo]) {
        guard let firstPhoto = photos.first else { return }
        currentImage = "https://kroya-api-production.up.railway.app/api/v1/fileView/\(firstPhoto.photo)"
    }
    
    // MARK: Thumbnails Overlay
    private var thumbnailsOverlay: some View {
        ScrollView(.horizontal, showsIndicators: false) { // Enable horizontal scrolling
            HStack(spacing: 5) {
                if let photos = ItemType == "FOOD_RECIPE" ? FoodDetailsVM.foodRecipeDetail?.photo : FoodDetailsVM.foodSellDetail?.foodRecipeDTO.photo {
                    ForEach(photos, id: \.photo) { photo in
                        if let url = URL(string: "https://kroya-api-production.up.railway.app/api/v1/fileView/\(photo.photo)") {
                            WebImage(url: url)
                                .resizable()
                                .onTapGesture {
                                    currentImage = url.absoluteString
                                }
                                .frame(width: 50, height: 50)
                                .cornerRadius(7)
                        }
                    }
                }
            }
            .padding(.horizontal, 2)
        }
        .padding(.top, 0)
        .frame(
            width: CGFloat((FoodDetailsVM.foodRecipeDetail?.photo.count ?? FoodDetailsVM.foodSellDetail?.foodRecipeDTO.photo.count ?? 0)) * 55,
            height: 60
        )
        .background(Color.white.opacity(0.5))
        .cornerRadius(11)
        .animation(.easeInOut, value: FoodDetailsVM.foodRecipeDetail?.photo.count ?? FoodDetailsVM.foodSellDetail?.foodRecipeDTO.photo.count ?? 0)
    }
    
    
}

