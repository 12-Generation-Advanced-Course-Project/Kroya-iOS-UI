
import SwiftUI

struct BottomSheetView<Content: View>: View {
    
    let content: Content
    @Binding var isOpen: Bool
    @State private var navigateToCheckout = false
    @State private var navigateToReceipt = false
    @State private var isPresented = false
    var itemType: String
    @ObservedObject var FoodDetails: FoodDetailsViewModel
    @StateObject private  var Profile =  ProfileViewModel()
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let showOrderButton: Bool // Control for Food vs Recipe view
    let notificationType: Int? // Control for status from Notification
    let showButtonInvoic : Bool // Control ler Button Invoice from Orders
    var invoiceAccept : Bool
    @GestureState private var translation: CGFloat = 0
    @State private var imageName: String = ""
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    private var isFullyExpanded: Bool {
        isOpen && translation == 0
    }
    init(
        isOpen: Binding<Bool>,
        maxHeight: CGFloat,
        minHeight: CGFloat,
        showOrderButton: Bool = true,
        notificationType: Int? = nil,
        showButtonInvoic: Bool = false,
        invoiceAccept: Bool = false,
        itemType: String,
        FoodDetails: FoodDetailsViewModel,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self._isOpen = isOpen
        self.maxHeight = maxHeight
        self.minHeight = minHeight
        self.showOrderButton = showOrderButton
        self.notificationType = notificationType
        self.showButtonInvoic = showButtonInvoic
        self.invoiceAccept = invoiceAccept
        self.itemType = itemType // Initialize itemType
        self.FoodDetails = FoodDetails // Initialize FoodDetails
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                self.indicator
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.5), value: isOpen)
            .gesture(
                DragGesture()
                    .updating(self.$translation) { value, state, _ in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        let snapDistance = maxHeight * 0.30
                        let velocity = value.predictedEndTranslation.height - value.translation.height
                        
                        if value.translation.height > snapDistance {
                            // Dragged down far enough - collapse
                            self.isOpen = false
                        } else if value.translation.height < -snapDistance || velocity < -300 {
                            // Dragged up far enough or with enough velocity - expand
                            self.isOpen = true
                        } else if value.translation.height < snapDistance {
                            // Close to top - automatically fit fullscreen
                            self.isOpen = true
                        }
                    }
            )
            
        }
    }
    
    
    private var indicator: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#D0DBEA"))
                .frame(width: 40, height: 5)
                .padding(.top, 22)
                .onTapGesture {
                    // Toggle the state when the user taps the bar
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.5)) {
                        self.isOpen.toggle()
                    }
                }
            HStack {
                if itemType == "FOOD_RECIPE" {
                    if let recipeDetails = FoodDetails.foodRecipeDetail {
                        Text(recipeDetails.name)
                            .font(.customfont(.bold, fontSize: 20))
                    } else {
                        ProgressView()
                            .frame(height: .screenHeight * 0.4)
                            .edgesIgnoringSafeArea(.top)
                    }
                } else if itemType == "FOOD_SELL" {
                    if let sellDetails = FoodDetails.foodSellDetail {
                        Text(sellDetails.foodRecipeDTO.name)
                            .font(.customfont(.bold, fontSize: 20))
                    } else {
                        ProgressView()
                            .frame(height: .screenHeight * 0.4)
                            .edgesIgnoringSafeArea(.top)
                    }
                }
                
                Spacer()
                //MARK: Show Accept or Reject from Notification
                if let notificationType = notificationType {
                    Text(notificationType == 1 ? LocalizedStringKey("Rejected") : LocalizedStringKey("Accepted "))
                        .font(.customfont(.medium, fontSize: 16))
                        .foregroundStyle(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.04)
                        .background(notificationType == 1 ?  Color.red : Color(hex: "#00BD4E") )
                        .cornerRadius(UIScreen.main.bounds.width * 0.022)
                }
                // MARK: Show Order Button if User is not the Food Owner
                if showOrderButton {
                    let foodOwnerID = FoodDetails.foodRecipeDetail?.user.id ?? FoodDetails.foodSellDetail?.foodRecipeDTO.user.id ?? 0
                    let currentUserID = Profile.userProfile?.id ?? 0
                    
                    if currentUserID != foodOwnerID {
                        // Current user is NOT the owner, show "Order" button
                        if let sellDetails = FoodDetails.foodSellDetail {
                            let imageName = sellDetails.foodRecipeDTO.photo.first?.photo ?? ""
                            Button(action: {
                                navigateToCheckout = true
                                print("\(foodOwnerID)")
                                print("\(currentUserID)")
                            }) {
                                HStack {
                                    Text("Order")
                                        .font(.customfont(.medium, fontSize: 16))
                                        .foregroundStyle(.white)
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 14, height: 14)
                                        .foregroundStyle(.white)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.04)
                                .background(PrimaryColor.normal)
                                .cornerRadius(UIScreen.main.bounds.width * 0.022)
                            }
                            .background(
                                NavigationLink(
                                    destination: FoodCheckOutView(
                                        imageName: .constant(imageName),
                                        Foodname: sellDetails.foodRecipeDTO.name,
                                        FoodId: sellDetails.id,
                                        Date: sellDetails.dateCooking,
                                        Price: sellDetails.price,
                                        Currency: sellDetails.currencyType,
                                        PhoneNumber: sellDetails.foodRecipeDTO.user.phoneNumber ?? "",
                                        ReciptentName: sellDetails.foodRecipeDTO.user.fullName
                                    ),
                                    isActive: $navigateToCheckout
                                ) {
                                    EmptyView()
                                }
                            )
                        }
                    } else {
                        
                        // Current user is the owner, hide "Order" button
                        Spacer().frame(width: 0, height: 0)
                    }
                    
                }
                
            }
        }.onAppear{
            Profile.fetchUserProfile()
        }
        .padding(.horizontal, 10)
        .padding(.top, 12)
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

