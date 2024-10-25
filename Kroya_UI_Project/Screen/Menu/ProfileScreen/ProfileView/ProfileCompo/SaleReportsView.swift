//
//  SaleReportsView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 15/10/24.


import SwiftUI

struct SaleReportView: View {
    @State private var selectedDate: Date = Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 1))!
    @Environment(\.dismiss) var dismiss
    
    // Formatter for displaying the day and month
    let dateFormatter = DateFormatter()
    
    // All available years for the picker
    let years = Array(2020...2100)
    
    // All months for the picker
    let months = Calendar.current.monthSymbols
    
    // Generate days based on the selected month and year
    var daysInSelectedMonth: [Date] {
        var dates = [Date]()
        let calendar = Calendar.current
        let components = DateComponents(year: selectedYear, month: selectedMonth)
        if let range = calendar.range(of: .day, in: .month, for: calendar.date(from: components)!) {
            for day in range {
                let date = calendar.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: day))!
                dates.append(date)
            }
        }
        return dates
    }
    
    // Example Date for earning Daily
    let dailyEarnings: [Date: Double] = [
        Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 3))!: 8.24
    ]
    
    let soldItems: [Date: [FoodItem]] = [
        Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 3))!: [

             FoodItem(name: "Brohok", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR", status: nil, timeAgo: nil),
             FoodItem(name: "Brohok", itemsCount: 2, remarks: "Not spicy", price: 2.24, paymentMethod: "KHQR", status: nil, timeAgo: nil)
            
        ]
    ]
    
    init() {
        dateFormatter.dateFormat = "dd MMM"
    }
    
    // Calculate the selected month and year dynamically based on the selectedDate
    var selectedMonth: Int {
        Calendar.current.component(.month, from: selectedDate)
    }
    
    var selectedYear: Int {
        Calendar.current.component(.year, from: selectedDate)
    }
    
    // Calculate total sales for the selected month and year
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
                        .cornerRadius(8)
                    Image("uil_arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                .overlay(
                    DatePicker(selection: $selectedDate, displayedComponents: .date) {
                    }
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
                        VStack {
                            Text(dateFormatter.string(from: date).components(separatedBy: " ").first!)
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundStyle(date == selectedDate ? PrimaryColor.normal : .black.opacity(0.6))
                            
                            Text(dateFormatter.string(from: date).components(separatedBy: " ").last!)
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundStyle(date == selectedDate ? PrimaryColor.normal : .black.opacity(0.6))
                            if date == selectedDate {
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
                            selectedDate = date
                        }
                        .padding(.horizontal, 5)
                    }
                }
                .padding(.horizontal)
            }
            
            HStack {
                Text("Earning")
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
            
            // Sold food items for the selected day
            if let items = soldItems[selectedDate] {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(items) { item in
                        ItemFoodOrderCard(item: item)
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                    }
                }
            } else {
                Text("No items sold on this day")
                    .foregroundColor(.gray)
                    .padding(.top)
            }
            Spacer()
        }
        .navigationTitle("Sale Report")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
