import SwiftUI

struct OrderCard: View {
    var isAccepted: Bool
    var isOrder: Bool
    var showIcon: Bool = false

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
                        .font(.customfont(.medium, fontSize: 15)) // Responsive font size
                        .fontWeight(.medium)

                    // Conditional display for Accept/Reject or Icon
                    if showIcon {
                        Spacer()
                        // Only the button will navigate to OrderListView
                        Button(action: {
                            print("Order")
                        }) {
                            ZStack {
                                Image(systemName: "list.clipboard") // Clipboard icon
                                    .foregroundColor(.gray)
                                
                                // Notification bubble
                                Text("4")
                                    .font(.customfont(.semibold, fontSize: 9))
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Circle().fill(Color.red))
                                    .offset(x: 8, y: -6)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .background(
                            NavigationLink(destination: OrderListView()) {
                                EmptyView()
                            }
                            .opacity(0) // NavigationLink invisible but functional
                        )
                    } else {
                        Spacer()
                        Text(isAccepted ? "Accept" : "Reject")
                            .font(.customfont(.medium, fontSize: 15)) // Responsive font size
                            .fontWeight(.medium)
                            .foregroundColor(isAccepted ? .green : .red)
                    }
                }

                Text("you are selling now")
                    .font(.customfont(.regular, fontSize: 12)) // Responsive font size
                    .opacity(0.6)

                // Price and Order/Sale Button
                HStack(spacing: 15) {
                    Text("$3.05")
                        .font(.customfont(.medium, fontSize: 15)) // Responsive font size
                        .fontWeight(.medium)

                    // Order/Sale Button based on isOrder boolean
                    Text(isOrder ? "Order" : "Sale")
                        .font(.customfont(.medium, fontSize: 15)) // Responsive font size
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isOrder ? PrimaryColor.normal.opacity(0.2) : Color(hex: "#DDF6C3"))
                                .frame(width: 50, height: 23)
                        )
                        .foregroundColor(isOrder ? .yellow : .green)
                }
            }
        }
    }
}

//
//
//#Preview {
//    VStack {
//        // Preview with the clipboard icon
//        OrderCard(isAccepted: true, isOrder: false, showIcon: true)
//            .frame(width: 400, height: 120) // Adjust to see the responsive behavior
//
//        // Preview with "Order" and "Accept" text
//        OrderCard(isAccepted: true, isOrder: true, showIcon: false)
//            .frame(width: 400, height: 120) // Adjust to see the responsive behavior
//
//        // Preview with "Order" and "Reject" text
//        OrderCard(isAccepted: false, isOrder: true, showIcon: false)
//            .frame(width: 400, height: 120) // Adjust to see the responsive behavior
//    }
//}
