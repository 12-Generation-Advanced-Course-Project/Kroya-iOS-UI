//import SwiftUI
//
//struct OrderCard: View {
//    
//    var isAccepted: Bool
//    var isOrder: Bool
//    var showIcon: Bool = false
//    @State private var navigateToOrderListView = false
//
//    var body: some View {
//        HStack {
//            // Image on the left
//            Image("Songvak")
//                .resizable()
//                .frame(width: 61, height: 62)
//                .cornerRadius(8)
//
//            VStack(alignment: .leading, spacing: 5) {
//                HStack {
//                    // Title and subtitle
//                    Text("Somlor Kari")
//                        .font(.customfont(.medium, fontSize: 15)) // Responsive font size
//                        .fontWeight(.medium)
//
//                    // Conditional display for Accept/Reject or Icon
//                    if showIcon {
//                        Spacer()
//                        // Only the button will navigate to OrderListView
//                        Button(action: {
//                            navigateToOrderListView = true
////                            print("Order")
//                        }) {
//                            ZStack {
//                                Image(systemName: "list.clipboard") // Clipboard icon
//                                    .foregroundColor(.gray)
//                                
//                                // Notification bubble
//                                Text("4")
//                                    .font(.customfont(.semibold, fontSize: 9))
//                                    .foregroundColor(.white)
//                                    .padding(4)
//                                    .background(Circle().fill(Color.red))
//                                    .offset(x: 8, y: -6)
//                            }
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                        .background(
//                            NavigationLink(destination: OrderListView(), isActive: $navigateToOrderListView) {
//                                EmptyView()
//                            }
////                            .opacity(0) // NavigationLink invisible but functional
//                        )
//                    } else {
//                        Spacer()
//                        Text(isAccepted ? "Accept" : "Reject")
//                            .font(.customfont(.medium, fontSize: 15)) // Responsive font size
//                            .fontWeight(.medium)
//                            .foregroundColor(isAccepted ? .green : .red)
//                    }
//                }
//
//                Text("you are selling now")
//                    .font(.customfont(.regular, fontSize: 12)) // Responsive font size
//                    .opacity(0.6)
//
//                // Price and Order/Sale Button
//                HStack(spacing: 15) {
//                    Text("$3.05")
//                        .font(.customfont(.medium, fontSize: 15)) // Responsive font size
//                        .fontWeight(.medium)
//
//                    // Order/Sale Button based on isOrder boolean
//                    Text(isOrder ? "Order" : "Sale")
//                        .font(.customfont(.medium, fontSize: 15)) // Responsive font size
//                        .background(
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(isOrder ? PrimaryColor.normal.opacity(0.2) : Color(hex: "#DDF6C3"))
//                                .frame(width: 50, height: 23)
//                        )
//                        .foregroundColor(isOrder ? .yellow : .green)
//                }
//            }
//        }
//    }
//}
//



import SwiftUI

struct OrderCard: View {
    
    var isAccepted: Bool
    var isOrder: Bool
    var showIcon: Bool = false
    @State private var navigateToOrderListView = false

    var body: some View {
        
        HStack {
            // Image on the left
            Image("Songvak")
                .resizable()
                .frame(width: 61, height: 62)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    // Title and subtitle
                    Text("Somlor Kari")
                        .font(.customfont(.medium, fontSize: 15))
                        .fontWeight(.medium)

                    // Conditional display for Accept/Reject or Icon
                    if showIcon {
                        Spacer()
                        Button(action: {
                            navigateToOrderListView = true
                        }) {
                            ZStack {
                                Image(systemName: "list.clipboard")
                                    .foregroundColor(.gray)

                                // Notification bubble
                                Text("3")
                                    .font(.customfont(.semibold, fontSize: 9))
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Circle().fill(Color.red))
                                    .offset(x: 8, y: -6)
                            }
                        }
                      
                        .background(
                            NavigationLink(destination: OrderListView(), isActive: $navigateToOrderListView) {
                                EmptyView()
                            }
                        )
                    } else {
                        Spacer()
                        Text(isAccepted ? "Accept" : "Reject")
                            .font(.customfont(.medium, fontSize: 15))
                            .fontWeight(.medium)
                            .foregroundColor(isAccepted ? .green : .red)
                    }
                }

                Text("you are selling now")
                    .font(.customfont(.regular, fontSize: 12))
                    .opacity(0.6)

                // Price and Order/Sale Button
                HStack(spacing: 15) {
                    Text("$3.05")
                        .font(.customfont(.medium, fontSize: 15))
                        .fontWeight(.medium)

                    // Order/Sale Button based on isOrder boolean
                    Text(isOrder ? "Order" : "Sale")
                        .font(.customfont(.medium, fontSize: 15))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isOrder ? PrimaryColor.normal.opacity(0.2) : Color(hex: "#DDF6C3"))
                        )
                        .foregroundColor(isOrder ? .yellow : .green)
                }
            }
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 12)
        .frame(width: 360)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                .background(Color.white.cornerRadius(12))
        )
    }
}
