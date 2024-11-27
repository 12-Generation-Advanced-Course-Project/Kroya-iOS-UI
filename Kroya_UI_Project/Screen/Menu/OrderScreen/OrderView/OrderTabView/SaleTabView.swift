import SwiftUI

struct SaleTabView: View {
    @Binding var searchText: String
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
        let filtered = searchText.isEmpty ? orderViewModel.orders.filter {
            $0.foodCardType == "SALE"
        } : orderViewModel.orders.filter {
            $0.foodCardType == "SALE" && $0.name.localizedCaseInsensitiveContains(searchText)
        }
        print("Filtered Orders for SaleTabView: \(filtered.map { $0.name })")
        return filtered
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

    let possibleDateFormats = [
        "yyyy-MM-dd'T'HH:mm:ss.SSS",
        "yyyy-MM-dd'T'HH:mm:ss",
        "yyyy-MM-dd'T'HH:mm",
        "yyyy-MM-dd HH:mm:ss",
        "yyyy-MM-dd"
    ]

    private func parseDate(_ dateString: String) -> Date? {
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

    private func groupOrdersByDate() -> [String: [OrderModel]] {
        var groupedOrders: [String: [OrderModel]] = ["Today": [], "Yesterday": [], "Last 2 Days": []]

        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!

        for order in filteredOrders {
            if let dateCookingStr = order.dateCooking,
               let dateCooking = parseDate(dateCookingStr) {
                if dateCooking >= today {
                    groupedOrders["Today"]?.append(order)
                } else if dateCooking >= yesterday && dateCooking < today {
                    groupedOrders["Yesterday"]?.append(order)
                } else if dateCooking >= twoDaysAgo && dateCooking < yesterday {
                    groupedOrders["Last 2 Days"]?.append(order)
                }
            }
        }

        for (key, orders) in groupedOrders {
            groupedOrders[key] = orders.sorted {
                if let date1 = parseDate($0.dateCooking ?? ""), let date2 = parseDate($1.dateCooking ?? "") {
                    return date1 > date2
                }
                return false
            }
        }

        print("Grouped and Sorted Orders by Date: \(groupedOrders)")
        return groupedOrders
    }
}
