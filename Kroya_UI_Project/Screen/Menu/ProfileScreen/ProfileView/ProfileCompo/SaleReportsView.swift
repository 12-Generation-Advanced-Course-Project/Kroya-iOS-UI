import SwiftUI

struct SaleReportView: View {
    @State private var selectedDate: Date = Date()
    @Environment(\.dismiss) var dismiss
    @State private var show3dot: Bool = false
    let dateFormatter = DateFormatter()
    let months = Calendar.current.monthSymbols
    @StateObject private var saleReportVM = SaleReportVM()
    
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
    
    init() {
        dateFormatter.dateFormat = "dd MMM" // For displaying dates as "01 Nov"
    }
    
    var selectedMonth: Int {
        Calendar.current.component(.month, from: selectedDate)
    }
    
    var selectedYear: Int {
        Calendar.current.component(.year, from: selectedDate)
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
                Text("$\(String(format: "%.2f", Double(saleReportVM.totalMonthlySales)))")
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
                            Text(dateFormatter.string(from: date).components(separatedBy: " ").first!) // Day
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundStyle(isFutureDate ? Color.gray : (date == selectedDate ? PrimaryColor.normal : .black.opacity(0.6)))
                            
                            Text(dateFormatter.string(from: date).components(separatedBy: " ").last!) // Month
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
                Text("$\(String(format: "%.2f", Double(saleReportVM.totalDailySales)))")
                    .font(.customfont(.semibold, fontSize: 18))
                    .foregroundStyle(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(PrimaryColor.normalHover)
            
            if !saleReportVM.purchaseResponses.isEmpty {
                ScrollView {
                    LazyVStack {
                        ForEach(saleReportVM.purchaseResponses) { order in
                            ItemFoodOrderCard(orderRequest: order, show3dot: $show3dot)
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                Text(LocalizedStringKey("No items sold on this day"))
                    .foregroundColor(.gray)
                    .padding(.top)
            }

            Spacer()
        }
        .onAppear {
            saleReportVM.fetchSaleReport(for: selectedDate)
        }
        .onChange(of: selectedDate) { newDate in
            saleReportVM.fetchSaleReport(for: newDate)
        }
        .navigationTitle(LocalizedStringKey("Sale Report"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SaleReportView_Previews: PreviewProvider {
    static var previews: some View {
        SaleReportView()
    }
}
