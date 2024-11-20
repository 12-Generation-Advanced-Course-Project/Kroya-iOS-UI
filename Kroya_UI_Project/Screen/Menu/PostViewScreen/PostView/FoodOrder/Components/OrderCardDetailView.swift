//
//  OrderCardDetailView.swift
//  Kroya
//
//  Created by KAK-LY on 11/10/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct OrderCardDetailView: View {
    
    @StateObject var viewModel: OrderCardDetailViewModel
    @Binding var imageName: String
    var url = Constants.fileupload
    var currency: String // Pass currency dynamically to display correct symbol
    @Binding var totalPrice: Int // Binding totalPrice
    @Binding var quantity: Int // Binding quantity
    
    var body: some View {
        VStack {
            // Header Section
            HStack {
                Text("Orders")
                    .font(.customfont(.semibold, fontSize: 16))
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 10)
            
            // Order Item Section
            VStack {
                HStack {
                    HStack(spacing: 15) {
                        if !imageName.isEmpty, let fullImageURL = URL(string: Constants.fileupload + imageName) {
                            WebImage(url: fullImageURL)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .cornerRadius(10)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .cornerRadius(10)
                                .foregroundColor(.gray)
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(viewModel.orderItem.name)
                                    .font(.customfont(.medium, fontSize: 16))
                                Spacer()
                                Text("\(currencySymbol(for: currency)) \(viewModel.orderItem.price, specifier: "%.2f")")
                                    .font(.customfont(.medium, fontSize: 16))
                            }
                            
                            Text("\(formatDate(viewModel.orderItem.date)) \(determineTimeOfDay(from: viewModel.orderItem.date))")
                                .font(.customfont(.light, fontSize: 10))
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // Quantity Controls Section
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.decrementQuantity()
                        quantity = viewModel.quantity
                        totalPrice = Int(viewModel.totalPrice)
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.yellow)
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove default button style
                    
                    Text("\(viewModel.quantity)")
                        .font(.customfont(.medium, fontSize: 16))
                        .padding(.horizontal, 10)
                    
                    Button(action: {
                        viewModel.incrementQuantity()
                        quantity = viewModel.quantity
                        totalPrice = Int(viewModel.totalPrice)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.yellow)
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove default button style
                }
                .padding(.vertical, 5)
            }
            .padding(.horizontal)
            
            // Total Price Section
            HStack {
                Text(LocalizedStringKey("Total"))
                    .font(.customfont(.semibold, fontSize: 16))
                Spacer()
                Text("\(currencySymbol(for: currency)) \(String(format: "%.2f", viewModel.totalPrice))")
                    .font(.customfont(.semibold, fontSize: 16))
                    .foregroundColor(.yellow)
                    .onAppear {
                        totalPrice = Int(viewModel.totalPrice)
                    }
            }

            .padding(.horizontal)
            .padding(.vertical, 10)
            .offset(y: 6)
            .frame(maxWidth: .infinity)
            .overlay(
                Rectangle()
                    .frame(height: 1.5)
                    .foregroundColor(Color(red: 0.836, green: 0.876, blue: 0.922)),
                alignment: .top
            )
        }
        .onAppear {
            totalPrice = Int(viewModel.totalPrice)
        }

        .frame(maxWidth: .infinity, minHeight: 200)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.836, green: 0.876, blue: 0.922), lineWidth: 1.5)
        )
    }
    
    // MARK: - Helper function to get the currency symbol
    private func currencySymbol(for currencyType: String) -> String {
        switch currencyType {
        case "DOLLAR":
            return "$"
        case "RIEL":
            return "៛"
        default:
            return ""
        }
    }
    
    // Helper functions for date and time remain unchanged
    private func parseDate(_ dateString: String) -> Date? {
        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSS",  // With milliseconds
            "yyyy-MM-dd'T'HH:mm:ss"       // Without milliseconds
        ]
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        for format in dateFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }

    private func formatDate(_ dateString: String) -> String {
        guard let date = parseDate(dateString) else { return "Invalid Date" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }

    private func determineTimeOfDay(from dateString: String) -> String {
        guard let date = parseDate(dateString) else { return "at current time." }
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 5..<12:
            return "in the morning."
        case 12..<17:
            return "in the afternoon."
        case 17..<21:
            return "in the evening."
        default:
            return "at night."
        }
    }
}
