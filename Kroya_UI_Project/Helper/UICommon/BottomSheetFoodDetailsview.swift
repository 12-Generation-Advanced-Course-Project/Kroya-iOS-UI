
import SwiftUI

struct BottomSheetView<Content: View>: View {
    
    let content: Content
    @Binding var isOpen: Bool
    @State private var navigateToCheckout = false
    @State private var navigateToReceipt = false
    @State private var isPresented = false
    var itemType: String
    @ObservedObject var FoodDetails: FoodDetailsViewModel
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
                //MARK: Show Order button if showOrderButton is true and not accessed from Notification
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
                //MARK: Show Button Invoice from Order
                else if showButtonInvoic {
                    Button(action: {
                        navigateToReceipt = true
                    }) {
                        HStack {
                            Text(LocalizedStringKey("Invoice"))
                                .font(.customfont(.medium, fontSize: 16))
                                .foregroundStyle(.white)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.04)
                        .background(invoiceAccept ? Color(hex: "#00BD4E") : Color.red)
                        .cornerRadius(UIScreen.main.bounds.width * 0.022)
                    }
                    .background(
                        NavigationLink(destination: ReceiptView(isPresented: $isPresented, isOrderReceived: false), isActive: $navigateToReceipt) {
                            EmptyView()
                        }
                    )
                }
                
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 12)
    }
}
