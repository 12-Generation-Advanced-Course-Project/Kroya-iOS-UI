
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
                        ZStack {
                            Color.white
                                .opacity(0.5)
                                .ignoresSafeArea()
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                                .scaleEffect(2)
                                .offset(y: 230)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if !orderViewModel.errorMessage.isEmpty {
                        Text("Error: \(orderViewModel.errorMessage)")
                            .foregroundColor(.red)
                    } else if orderViewModel.orders.isEmpty {
                        Text("No orders available.")
                            .foregroundColor(.gray)
                    } else {
                        let groupedOrders = groupOrdersByDate()
                        
                        // Display grouped orders
                        ForEach(["Today", "Yesterday", "Last 2 Days"], id: \.self) { group in
                            if let orders = groupedOrders[group], !orders.isEmpty {
                                OrderSection(group: group, orders: orders, isExpandedToday: $isExpandedToday, isExpandedYTD: $isExpandedYTD, isExpandedLst2Day: $isExpandedLst2Day)
                            } else {
                                // Display the section header even if there are no orders
                                OrderSection(group: group, orders: [], isExpandedToday: $isExpandedToday, isExpandedYTD: $isExpandedYTD, isExpandedLst2Day: $isExpandedLst2Day)
                            }
                        }
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
            orderViewModel.fetchPurchaseSale()
        }
    }
    
    private func groupOrdersByDate() -> [String: [OrderModel]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" // Adjust to your date format if needed
        
        var groupedOrders: [String: [OrderModel]] = ["Today": [], "Yesterday": [], "Last 2 Days": []]
        
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!
        
        for order in orderViewModel.orders {
            if let dateCookingStr = order.dateCooking,
               let dateCooking = dateFormatter.date(from: dateCookingStr) {
                if dateCooking >= today {
                    // Group orders with today's date or future dates in "Today"
                    groupedOrders["Today"]?.append(order)
                } else if Calendar.current.isDate(dateCooking, inSameDayAs: yesterday) {
                    // Group orders with yesterday's date in "Yesterday"
                    groupedOrders["Yesterday"]?.append(order)
                } else if dateCooking <= twoDaysAgo {
                    // Group orders with dates two days ago or older in "Last 2 Days"
                    groupedOrders["Last 2 Days"]?.append(order)
                }
            }
        }
        
        return groupedOrders
    }
}

struct OrderSection: View {
    let group: String
    let orders: [OrderModel]
    
    @Binding var isExpandedToday: Bool
    @Binding var isExpandedYTD: Bool
    @Binding var isExpandedLst2Day: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Custom label for the DisclosureGroup
            DisclosureGroup(
                isExpanded: bindingForGroup(),
                content: {
                    if orders.isEmpty {
                        Text("No orders available for \(group).")
                            .foregroundColor(.gray)
                            .padding(.vertical, 5)
                    } else {
                        VStack(spacing: 15) {
                            ForEach(orders, id: \.foodSellID) { order in
                                NavigationLink(destination: OrderListView(sellerId: orders.first!.foodSellID)) {
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
                },
                label: {
                    Text(group)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.vertical, 5)
                }
            )
            .accentColor(.black)
        }
    }
    
    private func bindingForGroup() -> Binding<Bool> {
        switch group {
        case "Today":
            return $isExpandedToday
        case "Yesterday":
            return $isExpandedYTD
        default:
            return $isExpandedLst2Day
        }
    }
}

