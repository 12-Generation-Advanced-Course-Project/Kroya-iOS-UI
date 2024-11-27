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
        var groupedOrders: [String: [OrderModel]] = ["Today": [], "Yesterday": [], "Last 2 Days": []]

        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!

        for order in filteredOrders {
            if let purchaseDateStr = order.purchaseDate,
               let purchaseDate = parseDate(purchaseDateStr) {
                if purchaseDate >= today {
                    // Group orders with today's date
                    groupedOrders["Today"]?.append(order)
                } else if purchaseDate >= yesterday && purchaseDate < today {
                    // Group orders with yesterday's date
                    groupedOrders["Yesterday"]?.append(order)
                } else if purchaseDate >= twoDaysAgo && purchaseDate < yesterday {
                    // Group orders with dates two days ago
                    groupedOrders["Last 2 Days"]?.append(order)
                }
            }
        }

        // Sort each group by `purchaseDate` in descending order
        for (key, orders) in groupedOrders {
            groupedOrders[key] = orders.sorted {
                if let date1 = parseDate($0.purchaseDate ?? ""), let date2 = parseDate($1.purchaseDate ?? "") {
                    return date1 > date2 // Descending order
                }
                return false
            }
        }

        print("Grouped and Sorted Orders by Date: \(groupedOrders)")
        return groupedOrders
    }

    // Helper function to parse dates
    private func parseDate(_ dateString: String) -> Date? {
        let possibleDateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd"
        ]

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        for format in possibleDateFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }

        print("Failed to parse date: \(dateString)")
        return nil
    }
}
