////
////  ItemFoodOrderCard.swift
////  Kroya_UI_Project
////
////  Created by KAK-LY on 17/11/24.
////
//
//import SwiftUI
//
//struct FoodItem: Identifiable {
//    
//    let id = UUID()
//    let name: String
//    let itemsCount: Int
//    let remarks: String
//    let price: Double
//    let paymentMethod: String
//    var status: String?
//    let timeAgo: String?
//}
//
//
//struct ItemFoodOrderCard: View {
//    
//    @Binding var item: FoodItem
//    var showEllipsis: Bool = true // Default to true for other uses
//    @State private var showPopover = false
//    @Binding  var show3dot :Bool
//    let Keyaccept = "Accept"
//    let Keyreject = "Reject"
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            HStack(spacing: 12) {
//                // Food image
//                Image("brohok")
//                    .resizable()
//                    .frame(width: 65, height: 65)
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(8)
//                
//                VStack(alignment: .leading, spacing: 5) {
//                    HStack(spacing: 8) {
//                        // Food name
//                        Text(item.name)
//                            .font(.customfont(.semibold, fontSize: 17))
//                            .foregroundColor(.black)
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(item.status == Keyaccept ? Color(hex: "#DDF6C3") : (item.status == Keyreject ? Color(hex: "#FFD8E4") : Color.clear))
//                                .frame(width: 50, height: 23)
//                            if show3dot == true {
//                                Text(item.status != nil ? (item.status == "Accept" ? "Accept" : "Reject") : "")
//                                    .font(.customfont(.regular, fontSize: 12))
//                                    .foregroundColor(item.status == "Accept" ? .green : (item.status == "Reject" ? .red : .clear))
//                            }
//                        }
//                        
//                        Spacer()
//                        // Time
//                        if let timeAgo = item.timeAgo {
//                            Text(timeAgo)
//                                .font(.customfont(.medium, fontSize: 12))
//                                .foregroundColor(.gray)
//                        }
//                        
//                        
//                        // Conditionally render the ellipsis button based on `showEllipsis`
//                        if showEllipsis {
//                            Button(action: {
//                                showPopover = true
//                            }, label: {
//                                Image(systemName: "ellipsis")
//                                    .rotationEffect(.degrees(90)) // Rotate to make it vertical
//                                    .font(.system(size: 18))
//                                    .foregroundColor(.gray)
//                                    .popover(isPresented: $showPopover,
//                                             attachmentAnchor: .point(.topLeading),
//                                             content: {
//                                        VStack(spacing: 8) {
//                                            Button("Accept", action: {
//                                                item.status = "Accept"
//                                                showPopover = false
//                                            })
//                                            .foregroundStyle(Color(hex: "#00941D"))
//                                            
//                                            Button("Reject", action: {
//                                                item.status = "Reject"
//                                                showPopover = false
//                                            })
//                                            .foregroundStyle(Color(hex: "#FF3B30"))
//                                        }
//                                        .frame(width: 130, height: 80)
//                                        .presentationCompactAdaptation(.popover)
//                                    })
//                            })
//                        }
//                        
//                    }
//                    
//                    // Item count and remarks
//                    Text("\(item.itemsCount) items")
//                        .font(.customfont(.medium, fontSize: 12))
//                        .foregroundColor(Color(hex: "#0A0019"))
//                        .opacity(0.5)
//                    
//                    Text("Remarks: \(item.remarks)")
//                        .font(.customfont(.medium, fontSize: 16))
//                        .foregroundColor(Color(hex: "#0A0019"))
//                        .opacity(0.5)
//                }
//            }
//            .padding([.horizontal, .top])
//            
//            // Location and contact details
//            HStack {
//                Group {
//                    
//                    Image(systemName: "scope")
//                        .foregroundColor(.yellow)
//                    Text("St 323 - Toeul kork")
//                    
//                    Spacer()
//                    
//                        .frame(width: 22)
//                    Image(systemName: "phone.fill")
//                        .foregroundColor(.yellow)
//                    Text("cheata, ")
//                    +
//                    Text("016 860 375")
//                }
//                .font(.customfont(.semibold, fontSize: 14))
//            }
//            .padding(.horizontal, 10)
//            .foregroundColor(Color(hex: "#7B7D92"))
//            
//            // Divider
//            Divider()
//                .frame(maxWidth: .infinity)
//                .foregroundColor(Color(red: 0.836, green: 0.875, blue: 0.924))
//            
//            // Price and payment method
//            HStack {
//                Spacer()
//                VStack(alignment: .trailing, spacing: 10) {
//                    HStack {
//                        Text(LocalizedStringKey("Total"))
//                        Spacer()
//                        Text("$\(String(format: "%.2f", item.price))")
//                    }
//                    .foregroundStyle(Color(hex: "#0A0019"))
//                    .font(.customfont(.semibold, fontSize: 14))
//                    
//                    HStack {
//                        Text(LocalizedStringKey("Pay with \(item.paymentMethod)"))
//                        Spacer()
//                        Text("$\(String(format: "%.2f", item.price))")
//                    }
//                    .foregroundStyle(Color(hex: "#0A0019"))
//                    .font(.customfont(.semibold, fontSize: 14))
//                }
//            }
//            .padding(.horizontal, 10)
//            .padding(.vertical, 10)
//        }
//        .frame(maxWidth: .infinity)
//        .background(Color.white)
//        .cornerRadius(8)
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(Color(red: 0.836, green: 0.875, blue: 0.924), lineWidth: 1.5)
//        )
//    }
//}
