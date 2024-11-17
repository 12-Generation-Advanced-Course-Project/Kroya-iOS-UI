
import SwiftUI

struct OrderTabView: View {
    
    @StateObject private var orderViewModel = OrderViewModel()
    
    @State private var isExpandedToday = true
    @State private var isExpandedYTD = false
    @State private var isExpandedLst2Day = false
    
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
                    } else if orderViewModel.orders.isEmpty {
                        // Display no orders message
                        Text("No orders available.")
                            .foregroundColor(.gray)
                    } else {
                        // Display grouped orders
                        let groupedOrders = groupOrdersByDate()
                        ForEach(["Today", "Yesterday", "Last 2 Days"], id: \.self) { group in
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
    
    private func groupOrdersByDate() -> [String: [OrderModel]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" // Adjust to your date format if needed

        var groupedOrders: [String: [OrderModel]] = ["Today": [], "Yesterday": [], "Last 2 Days": []]

        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!
        
        // Filter orders with foodCardType "ORDER"
        _ = orderViewModel.orders.filter { $0.foodCardType == "ORDER" }

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


