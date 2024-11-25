

import SwiftUI

struct OrderTabView: View {
    
    @Binding var searchText: String // Pass search text from parent
    @StateObject private var orderViewModel = OrderViewModel() // Shared ViewModel
    
    @State private var isExpandedToday = true
    @State private var isExpandedYTD = false
    @State private var isExpandedLst2Day = false
    
    @State private var arrayDays: [String] = ["Today", "Yesterday", "Last 2 Days"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    // Display loading state
                    if orderViewModel.isLoading {
                        loadingView
                    } else if !orderViewModel.errorMessage.isEmpty {
                        // Display error message
                        Text("Error: \(orderViewModel.errorMessage)")
                            .foregroundColor(.red)
                    } else if filteredOrders.isEmpty {
                        // Display no orders message
                        Text("No orders available.")
                            .foregroundColor(.gray)
                    } else {
                        // Display grouped orders
                        let groupedOrders = groupOrdersByDate()
                        ForEach(arrayDays, id: \.self) { group in
                            if let orders = groupedOrders[group], !orders.isEmpty {
                                OrderSection(group: group, orders: orders, isExpandedToday: $isExpandedToday, isExpandedYTD: $isExpandedYTD, isExpandedLst2Day: $isExpandedLst2Day)
                            } else {
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
            orderViewModel.fetchPurchaseOrder()
        }
    }
    
    private var loadingView: some View {
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
    }
    
    // Filter orders by search text
    private var filteredOrders: [OrderModel] {
        if searchText.isEmpty {
            return orderViewModel.orders.filter { $0.foodCardType == "ORDER" }
        }
        return orderViewModel.orders.filter {
            $0.foodCardType == "ORDER" &&
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private func groupOrdersByDate() -> [String: [OrderModel]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" // Adjust to your date format if needed

        var groupedOrders: [String: [OrderModel]] = ["Today": [], "Yesterday": [], "Last 2 Days": []]

        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!
        
        for order in filteredOrders { // Use filtered orders here
            if let purchaseDateStr = order.purchaseDate,
               let purchaseDate = dateFormatter.date(from: purchaseDateStr) {
                if purchaseDate >= today {
                    // Group orders with today's date or future dates in "Today"
                    groupedOrders["Today"]?.append(order)
                } else if Calendar.current.isDate(purchaseDate, inSameDayAs: yesterday) {
                    // Group orders with yesterday's date in "Yesterday"
                    groupedOrders["Yesterday"]?.append(order)
                } else if purchaseDate <= twoDaysAgo {
                    // Group orders with dates two days ago or older in "Last 2 Days"
                    groupedOrders["Last 2 Days"]?.append(order)
                }
            }
        }

        return groupedOrders
    }
}
