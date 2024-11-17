import SwiftUI

struct SaleReportView: View {
    
//    @State private var selectedDate: Date = Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 1))!
    @State private var selectedDate: Date = Date()
    @Environment(\.dismiss) var dismiss
    @State private var ishow3dot: Bool = false
    let dateFormatter = DateFormatter()
    let years = Array(2020...2100)
    let months = Calendar.current.monthSymbols
    
    var daysInSelectedMonth: [Date] {
        var dates = [Date]()
        let calendar = Calendar.current
        let components = DateComponents(year: selectedYear, month: selectedMonth)
        if let range = calendar.range(of: .day, in: .month, for: calendar.date(from: components)!) {
            for day in range {
                if let date = calendar.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: day)) {
                    dates.append(date)
                }
            }
        }
        return dates
    }
    
    // Example data for daily earnings and sold items
    let dailyEarnings: [Date: Double] = [
        Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 3))!: 8.24
    ]
    
    let soldItems: [Date: [FoodItem]] = [
        Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 3))!: [
            FoodItem(name: "Brohok", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR", status: nil, timeAgo: nil),
            FoodItem(name: "Somlor Kari", itemsCount: 2, remarks: "Not spicy", price: 6, paymentMethod: "KHQR", timeAgo: "15m ago")
        ]
    ]
    
    init() {
        dateFormatter.dateFormat = "dd MMM"
    }
    
    var selectedMonth: Int {
        Calendar.current.component(.month, from: selectedDate)
    }
    
    var selectedYear: Int {
        Calendar.current.component(.year, from: selectedDate)
    }
    
    var totalSalesForSelectedMonth: Double {
        let monthStartDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1))!
        let monthEndDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth + 1, day: 1))!
        return dailyEarnings.filter { (date, _) in
            return date >= monthStartDate && date < monthEndDate
        }.values.reduce(0, +)
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 15)
            HStack {
                HStack {
                    Text("\(months[selectedMonth - 1]) \(String(format: "%d", selectedYear))")
                        .font(.customfont(.semibold, fontSize: 18))
                        .foregroundStyle(.black.opacity(0.8))
                    Image("uil_arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                .overlay(
                    DatePicker(selection: $selectedDate, in: ...Date(), displayedComponents: .date) { }
                        .labelsHidden()
                        .colorMultiply(.clear)
                )

                Spacer()
                Text("$\(String(format: "%.2f", totalSalesForSelectedMonth))")
                    .font(.customfont(.semibold, fontSize: 18))
                    .foregroundStyle(PrimaryColor.normalHover)
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(daysInSelectedMonth, id: \.self) { date in
                        let isFutureDate = date > Date()
                        
                        VStack {
                            Text(dateFormatter.string(from: date).components(separatedBy: " ").first!)
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundStyle(isFutureDate ? Color.gray : (date == selectedDate ? PrimaryColor.normal : .black.opacity(0.6)))
                            
                            Text(dateFormatter.string(from: date).components(separatedBy: " ").last!)
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundStyle(isFutureDate ? Color.gray : (date == selectedDate ? PrimaryColor.normal : .black.opacity(0.8)))
                            
                            if date == selectedDate && !isFutureDate {
                                Image("pyramid")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                            } else {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 15, height: 15)
                            }
                        }
                        .onTapGesture {
                            if !isFutureDate {
                                selectedDate = date
                            }
                        }
                        .padding(.horizontal, 5)
                        .disabled(isFutureDate)
                    }
                }
                .padding(.horizontal)
            }
            
            HStack {
                Text(LocalizedStringKey("Earning"))
                    .font(.customfont(.semibold, fontSize: 18))
                    .foregroundStyle(.white)
                Spacer()
                Text("$\(String(format: "%.2f", dailyEarnings[selectedDate] ?? 0.0))")
                    .font(.customfont(.semibold, fontSize: 18))
                    .foregroundStyle(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(PrimaryColor.normalHover)
            
            Spacer()
            
            if let items = soldItems[selectedDate] {
                NewItemFoodOrderCardView(show3dot: $ishow3dot, showEllipsis: false, foodItems: items) // Setting `showEllipsis` to false here
//                    .padding(.top, 18)
                    .padding(.vertical, 8)
            } else {
                Text(LocalizedStringKey("No items sold on this day"))
                    .foregroundColor(.gray)
                    .padding(.top)
            }

            Spacer()
        }
        .navigationTitle(LocalizedStringKey("Sale Report"))
        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.black)
                    }
                }
            }
        }
    }
}

struct SaleReportView_Previews: PreviewProvider {
    static var previews: some View {
        SaleReportView()
    }
}
