
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
                .padding(.top, 22)
            
            HStack {
                Text("Somlor Mju")
                    .font(.customfont(.bold, fontSize: 20))
                Spacer()
                
                // Show Accept or Reject from Notification
                if let notificationType = notificationType {

                    Text(notificationType == 1 ? LocalizedStringKey("Rejected") : LocalizedStringKey("Accepted "))
                        .font(.customfont(.medium, fontSize: 16))
                        .foregroundStyle(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.04)
                        .background(notificationType == 1 ?  Color.red : Color(hex: "#00BD4E") )
                        .cornerRadius(UIScreen.main.bounds.width * 0.022)
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
        .padding(.horizontal, 15)
        .padding(.top, 12)
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
