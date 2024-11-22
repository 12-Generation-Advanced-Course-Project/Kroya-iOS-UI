import SwiftUI
struct SaleTabView: View {
    @Binding var searchText: String // Pass search text from parent
    @StateObject private var orderViewModel = OrderViewModel()

    @State private var isExpandedToday = true
    @State private var isExpandedYTD = false
    @State private var isExpandedLst2Day = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    if orderViewModel.isLoading {
                        loadingView
                    } else if filteredOrders.isEmpty {
                        Text("No orders available.").foregroundColor(.gray)
                    } else {
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
            orderViewModel.fetchPurchaseSale()
        }
    }

    private var filteredOrders: [OrderModel] {
        if searchText.isEmpty {
            return orderViewModel.orders
        }
        return orderViewModel.orders.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    private func groupOrdersByDate() -> [String: [OrderModel]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        var groupedOrders: [String: [OrderModel]] = ["Today": [], "Yesterday": [], "Last 2 Days": []]

        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!

        for order in filteredOrders { // Use filtered orders
            if let dateCookingStr = order.dateCooking,
               let dateCooking = dateFormatter.date(from: dateCookingStr) {
                if dateCooking >= today {
                    groupedOrders["Today"]?.append(order)
                } else if Calendar.current.isDate(dateCooking, inSameDayAs: yesterday) {
                    groupedOrders["Yesterday"]?.append(order)
                } else if dateCooking <= twoDaysAgo {
                    groupedOrders["Last 2 Days"]?.append(order)
                }
            }
        }

        return groupedOrders
    }

    private var loadingView: some View {
        ZStack {
            Color.white.opacity(0.5).ignoresSafeArea()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                .scaleEffect(2)
                .offset(y: 230)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
