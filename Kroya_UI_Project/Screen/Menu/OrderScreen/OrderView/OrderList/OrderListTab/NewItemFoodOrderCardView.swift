import SwiftUI

struct NewItemFoodOrderCardView: View {
    
    @State private var isPresented = false
    @Binding var show3dot: Bool
    let showEllipsis: Bool
    @Environment(\.dismiss) var dismiss
    @StateObject private var orderRequestVM = OrderRequestViewModel()
    var sellerId: Int
    
    var body: some View {
        NavigationView {
            VStack {
                // Loading Indicator
                if orderRequestVM.isLoading {
                    ZStack {
                        Color.white
                            .edgesIgnoringSafeArea(.all)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                            .scaleEffect(2)
                            .offset(y: -80)
                    }
                }
                // No Data Case
                else if orderRequestVM.ordersRequestModel.isEmpty {
                    Text("No Order Request")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.top, 50) // Adds spacing from the top
                }
                // Display Orders
                else {
                    ScrollView {
                        LazyVStack {
                            ForEach(orderRequestVM.ordersRequestModel.indices, id: \.self) { index in
                                ItemFoodOrderCard(orderRequest: $orderRequestVM.ordersRequestModel[index], show3dot: $show3dot)
                                    .onTapGesture {
                                        let foodSale = orderRequestVM.ordersRequestModel[index]
                                        print(foodSale.id)
                                        print(foodSale.purchaseDate ?? "")
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .scrollIndicators(.hidden)
                    
                    Spacer()
                }
            }
            .onAppear {
                orderRequestVM.fetchOrderForSellerById(sellerId: sellerId)
            }
        }
    }
}
