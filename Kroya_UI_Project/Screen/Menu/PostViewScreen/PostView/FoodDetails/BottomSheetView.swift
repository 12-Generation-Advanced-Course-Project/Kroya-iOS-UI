
import SwiftUI

struct BottomSheetView<Content: View>: View {
    
    let content: Content
    @Binding var isOpen: Bool
    @State private var navigateToCheckout = false
    @State private var navigateToReceipt = false
    @State private var isPresented = false
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let showOrderButton: Bool // Control for Food vs Recipe view
    let notificationType: Int? // Control for status from Notification
    let showButtonInvoic : Bool // Control ler Button Invoice from Orders
    var invoiceAccept : Bool
    @GestureState private var translation: CGFloat = 0
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    private var isFullyExpanded: Bool {
        isOpen && translation == 0
    }
    
    private var indicator: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#D0DBEA"))
                .frame(width: 40, height: 5)
                .padding(.top, 20)
            
            HStack {
                Text("Somlor Mju")
                    .font(.customfont(.bold, fontSize: 20))
                Spacer()
                
                // Show Accept or Reject from Notification
                if let notificationType = notificationType {
                    // Display status based on notificationType
                    Text(notificationType == 1 ? "Rejected" : "Accepted ")
                        .font(.customfont(.medium, fontSize: 16))
                        .foregroundStyle(notificationType == 1 ? .red : .green)
                }
                // Show Order button if showOrderButton is true and not accessed from Notification
                else if showOrderButton {
                    Button(action: {
                        navigateToCheckout = true
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
                        NavigationLink(destination: FoodCheckOutView(), isActive: $navigateToCheckout) {
                            EmptyView()
                        }
                    )
                }
      //  Show Button Invoice from Order
                else if showButtonInvoic {
                    Button(action: {
                        navigateToReceipt = true
                    }) {
                        HStack {
                            Text("Invoice")
                                .font(.customfont(.medium, fontSize: 16))
                                .foregroundStyle(.white)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.04)
                        .background(invoiceAccept ? Color(hex: "#00BD4E") : Color.red)
                        .cornerRadius(UIScreen.main.bounds.width * 0.022)
                    }
                    .background(
                        NavigationLink(destination: ReceiptView(isPresented: $isPresented), isActive: $navigateToReceipt) {
                            EmptyView()
                        }
                    )
                }
                
            }
        }
        .padding(.horizontal, 15)
        .padding(.top, 8)
    }
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, minHeight: CGFloat, showOrderButton: Bool = true, notificationType: Int? = nil, showButtonInvoic: Bool = false, invoiceAccept: Bool = false, @ViewBuilder content: () -> Content) {
         self.content = content()
         self._isOpen = isOpen
         self.maxHeight = maxHeight
         self.minHeight = minHeight
         self.showOrderButton = showOrderButton
         self.notificationType = notificationType
         self.showButtonInvoic = showButtonInvoic
         self.invoiceAccept = invoiceAccept
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
            .gesture(
                DragGesture()
                    .updating(self.$translation) { value, state, _ in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        let snapDistance = self.maxHeight * 0.25
                        if value.translation.height > snapDistance {
                            self.isOpen = false
                        } else if value.translation.height < -snapDistance {
                            self.isOpen = true
                        }
                    }
            )
        }
    }
}



struct FoodDetailView: View {
    @State private var isFavorite: Bool = false
    @State private var currentImage: String
    @State private var isBottomSheetOpen: Bool = false
    @State private var isShowPopup: Bool = false  // Popup control here
    var showPrice: Bool
    var showOrderButton: Bool
    var showButtonInvoic: Bool
    var invoiceAccept: Bool
    var notificationType: Int? // Notification type for status display
    var theMainImage: String
    var subImage1: String
    var subImage2: String
    var subImage3: String
    var subImage4: String
    @Environment(\.dismiss) var dismiss
    
    init(theMainImage: String, subImage1: String, subImage2: String, subImage3: String, subImage4: String, showOrderButton: Bool = true, showPrice: Bool = false, showButtonInvoic: Bool = false, invoiceAccept: Bool = false, notificationType: Int? = nil) {
          self.theMainImage = theMainImage
          self.subImage1 = subImage1
          self.subImage2 = subImage2
          self.subImage3 = subImage3
          self.subImage4 = subImage4
          self.showOrderButton = showOrderButton
          self.showPrice = showPrice
          self.showButtonInvoic = showButtonInvoic
          self.invoiceAccept = invoiceAccept
          self.notificationType = notificationType
          _currentImage = State(initialValue: theMainImage)
      }
    
    var body: some View {
        
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            let screenWidth = geometry.size.width
            let frameHeight = screenHeight * 0.4
            
            ZStack {
                // Main Food Detail Content
                VStack {
                    Image(currentImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: .screenWidth, height: .screenHeight * 0.4)
                        .clipped()
                        .edgesIgnoringSafeArea(.top)
                        .overlay {
                            HStack {
                                Button(action: {
                                    dismiss()
                                }) {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: .screenWidth * 0.07, height: .screenHeight * 0.07)
                                        .overlay(
                                            Image(systemName: "arrow.left")
                                                .foregroundColor(.black)
                                                .font(.system(size: 17))
                                        )
                                }
                                Spacer()
                                Button(action: {
                                    isFavorite.toggle()
                                }) {
                                    Circle()
                                        .fill(isFavorite ? Color(hex: "#FE724C") : Color.white.opacity(0.5))
                                        .frame(width: .screenWidth * 0.07, height: .screenHeight * 0.07)
                                        .overlay(
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                        )
                                }
                                .shadow(color: isFavorite ? Color.red.opacity(0.5) : Color.gray.opacity(0.5), radius: 4, x: 0, y: 4)
                            }
                            .offset(y: -.screenHeight * 0.18)
                            .padding(.horizontal,. screenWidth * 0.045)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 11)
                                .fill(Color.white.opacity(0.5))
                                .frame(width: .screenWidth * 0.55, height: .screenHeight * 0.068)
                                .overlay(
                                    HStack(spacing: 5) {
                                        Group {
                                            Image(subImage1)
                                                .resizable()
                                                .onTapGesture {
                                                    currentImage = subImage1
                                                }
                                            Image(subImage2)
                                                .resizable()
                                                .onTapGesture {
                                                    currentImage = subImage2
                                                }
                                            Image(subImage3)
                                                .resizable()
                                                .onTapGesture {
                                                    currentImage = subImage3
                                                }
                                            Image(subImage4)
                                                .resizable()
                                                .onTapGesture {
                                                    currentImage = subImage4
                                                }
                                        }
                                        .frame(width: .screenWidth * 0.12, height: .screenWidth * 0.11)
                                        .cornerRadius(7)
                                    }
                                )
                                .offset(y: -.screenHeight * 0.0007)
                        )
                    Spacer()
                }
                
                // Bottom Sheet Content
                BottomSheetView(isOpen: $isBottomSheetOpen, maxHeight: .screenHeight * 1, minHeight: .screenHeight * 0.645, showOrderButton: showOrderButton, notificationType: notificationType, showButtonInvoic: showButtonInvoic, invoiceAccept: invoiceAccept) {
                                  ContentView(showPrice: showPrice, isShowPopup: $isShowPopup)
                                      .padding(.horizontal, 15)
                              }
                .edgesIgnoringSafeArea(.all)
                // Show the popup in full screen
                if isShowPopup {
                    PopupReview(profile: "Songvak", userName: "Chhoy Sreynoch", description: "", isReviewPopupOpen: $isShowPopup)
                        .background(Color.black.opacity(0.5))  // Background dim effect
                        .edgesIgnoringSafeArea(.all)
                }
            }
            
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    FoodDetailView(
        theMainImage: "Songvak",
        subImage1: "ahmok",
        subImage2: "brohok",
        subImage3: "somlorKari",
        subImage4: "Songvak"
    )
}
