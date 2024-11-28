import SwiftUI


struct AllTabView: View {
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
                    if orderViewModel.isLoading {
                        ForEach(0..<max(1, orderViewModel.orders.count)) { _ in
                            OrderCard(order: .placeholder, showIcon: true)
                                .redacted(reason: .placeholder)
                        }
                    } else if !orderViewModel.errorMessage.isEmpty {
                        Text("Error: \(orderViewModel.errorMessage)")
                            .foregroundColor(.red)
                    } else if filteredOrdersAndSales.isEmpty {
                        Text("No items available.")
                            .foregroundColor(.gray)
                    } else {
                        let groupedItems = groupOrdersAndSalesByDate()
                        ForEach(arrayDays, id: \.self) { group in
                            if let items = groupedItems[group], !items.isEmpty {
                                OrderSection(
                                    group: group,
                                    orders: items,
                                    isExpandedToday: $isExpandedToday,
                                    isExpandedYTD: $isExpandedYTD,
                                    isExpandedLst2Day: $isExpandedLst2Day
                                )
                            } else {
                                OrderSection(
                                    group: group,
                                    orders: [],
                                    isExpandedToday: $isExpandedToday,
                                    isExpandedYTD: $isExpandedYTD,
                                    isExpandedLst2Day: $isExpandedLst2Day
                                )
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

    // Combine and filter orders and sales by search text
    private var filteredOrdersAndSales: [OrderModel] {
        let combined = orderViewModel.orders
        if searchText.isEmpty {
            return combined
        }
        return combined.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    // Group combined orders and sales by date
    private func groupOrdersAndSalesByDate() -> [String: [OrderModel]] {
        var groupedItems: [String: [OrderModel]] = ["Today": [], "Yesterday": [], "Last 2 Days": []]

        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!

        for item in filteredOrdersAndSales {
            let dateToCompare = item.foodCardType == "ORDER" ? item.purchaseDate : item.dateCooking
            if let dateString = dateToCompare, let date = parseDate(dateString) {
                if date >= today {
                    groupedItems["Today"]?.append(item)
                } else if date >= yesterday && date < today {
                    groupedItems["Yesterday"]?.append(item)
                } else if date >= twoDaysAgo && date < yesterday {
                    groupedItems["Last 2 Days"]?.append(item)
                }
            }
        }

        // Sort each group by the most recent date
        for (key, items) in groupedItems {
            groupedItems[key] = items.sorted {
                let date1 = parseDate($0.foodCardType == "ORDER" ? $0.purchaseDate ?? "" : $0.dateCooking ?? "") ?? Date.distantPast
                let date2 = parseDate($1.foodCardType == "ORDER" ? $1.purchaseDate ?? "" : $1.dateCooking ?? "") ?? Date.distantPast
                return date1 > date2
            }
        }

        print("Grouped and Sorted Orders and Sales by Date: \(groupedItems)")
        return groupedItems
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

struct OrderSection: View {
    let group: String
    let orders: [OrderModel]
    
    @Binding var isExpandedToday: Bool
    @Binding var isExpandedYTD: Bool
    @Binding var isExpandedLst2Day: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            DisclosureGroup(
                isExpanded: bindingForGroup(),
                content: {
                    if orders.isEmpty {
                        Text("No orders available for \(group).")
                            .foregroundColor(.gray)
                            .padding(.vertical, 5)
                    } else {
                        VStack(spacing: 15) {
                            ForEach(orders, id: \.id) { order in
                                OrderCard(order: order, showIcon: true)
                            }
                        }
                    }
                },
                label: {
                    Text("\(group) (\(orders.count))")
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
