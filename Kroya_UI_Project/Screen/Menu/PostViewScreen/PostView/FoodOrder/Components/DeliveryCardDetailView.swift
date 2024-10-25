//
//  DeliveryCardDetailView.swift
//  Kroya
//
//  Created by KAK-LY on 11/10/24.
//

import SwiftUI

struct DeliveryCardDetailView: View {
    
    @StateObject var viewModel: DeliveryCardDetailViewModel
    
    var body: some View {
        VStack {
            // Title and navigation chevron
            HStack {
                Text("Delivery to")
                    .font(.customfont(.semibold, fontSize: 16))
                Spacer()
  
                Button(action: {
                    // Action for cash payment
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(PlainButtonStyle()) // Remove default button style
            }
            .padding(.horizontal)
            .padding(.top, 15)
            
            // Delivery information
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    HStack(spacing: 15){
                        Image(systemName: "mappin.and.ellipse")
                            .frame(width: 20, height: 20)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(viewModel.deliveryInfo.locationName)
                                .font(.customfont(.medium, fontSize: 16))
                            
                            Text(viewModel.deliveryInfo.address)
                                .font(.customfont(.medium, fontSize: 14))
                                .foregroundColor(Color.gray)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "phone.fill")
                            .frame(width: 20, height: 20)
                        
                        VStack(alignment: .leading) {
                            Text("\(viewModel.deliveryInfo.recipient), \(viewModel.deliveryInfo.phoneNumber)")
                                .font(.customfont(.medium, fontSize: 16))
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            // Remarks and notes
            HStack {
                HStack {
                    Text("Remarks")
                        .font(.customfont(.medium, fontSize: 16))
                    Spacer()
                    Text(viewModel.deliveryInfo.remarks ?? "Notes (optional)")
                        .font(.customfont(.medium, fontSize: 16))
                        .foregroundColor(viewModel.deliveryInfo.remarks == nil ? .gray : .primary)
                    Spacer()
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .overlay(
                Rectangle()
                    .frame(height: 1.5)
                    .foregroundColor(Color(red: 0.836, green: 0.876, blue: 0.922)),
                alignment: .top
            )
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.836, green: 0.876, blue: 0.922), lineWidth: 1.5)
        )
    }
}

#Preview {
    
    DeliveryCardDetailView(viewModel: DeliveryCardDetailViewModel(deliveryInfo: DeliveryInfo(
        locationName: "HRD Center",
        address: "St 323 - Toul Kork",
        recipient: "Cheata",
        phoneNumber: "+85593333929",
        remarks: nil
    )))
}
