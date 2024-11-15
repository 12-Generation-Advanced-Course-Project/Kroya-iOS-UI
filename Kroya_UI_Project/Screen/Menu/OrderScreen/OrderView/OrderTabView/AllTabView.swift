
import SwiftUI

struct AllTabView: View {
    
    @StateObject private var orderViewModel = OrderViewModel() // Initialize the OrderViewModel
    
    @State private var isExpandedToday = true
    @State private var isExpandedYTD = false
    @State private var isExpandedLst2Day = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    // Loading and error handling
                    if orderViewModel.isLoading {
                        ProgressView("Loading...")
                    } else if !orderViewModel.errorMessage.isEmpty {
                        Text("Error: \(orderViewModel.errorMessage)")
                            .foregroundColor(.red)
                    } else if orderViewModel.orders.isEmpty {
                        Text("No orders available.")
                            .foregroundColor(.gray)
                    } else {
                        // Display orders in Disclosure Group for Today
                        DisclosureGroup("Today", isExpanded: $isExpandedToday) {
                            VStack(spacing: 15) {
                                ForEach(orderViewModel.orders, id: \.foodSellID) { order in
                                    NavigationLink(destination: OrderListView()) {
                                        OrderCard(
                                            order: order,
                                            isAccepted: order.purchaseStatusType == "Accepted",
                                            isOrder: order.isOrderable,
                                            showIcon: true
                                        )
                                    }
                                }
                            }
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .accentColor(.black)
                        .animation(.easeInOut(duration: 0.3), value: isExpandedToday)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 5)
            }
            .background(Color.clear)
            .scrollIndicators(.hidden)
        }
        .onAppear {
            orderViewModel.fetchAllPurchase()
        }
    }
}

