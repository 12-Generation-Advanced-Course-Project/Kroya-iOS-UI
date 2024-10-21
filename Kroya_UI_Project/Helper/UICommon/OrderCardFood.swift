import SwiftUI

struct OrderCard: View {
    var isAccepted: Bool
    var isOrder: Bool
    var showIcon: Bool = false 
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                // Image on the left
                Image("Songvak")
                    .resizable()
                    .frame(width: min(75, geometry.size.width * 0.2), height: min(75, geometry.size.width * 0.2))
                    .cornerRadius(8)
                 //   .padding(10)
                
                VStack(alignment: .leading, spacing: 5) {
                    // Title and subtitle
                    Text("Somlor Kari")
                        .font(.customfont(.medium, fontSize: 15)) // Responsive font size
                        .fontWeight(.medium)
                        .padding(.top, 7)
                    
                    Text("you are selling now")
                        .font(.customfont(.regular, fontSize: 12)) // Responsive font size
                        .opacity(0.6)
                        .padding(.bottom, 10)
                    // Price and Order/Sale Button
                    HStack(spacing: 15) {
                        Text("$3.05")
                            .font(.customfont(.medium, fontSize: 15)) // Responsive font size
                            .fontWeight(.medium)
                        
                        // Order/Sale Button based on isOrder boolean
                        Text(isOrder ? "Order" : "Sale")
                            .font(.customfont(.medium, fontSize: 15)) // Responsive font size
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(isOrder ? PrimaryColor.normal.opacity(0.2) : Color(hex: "#DDF6C3"))
                            )
                            .foregroundColor(isOrder ? .yellow : .green)
                    }
                    .padding(.bottom, 5)
                }
                .layoutPriority(1) // Ensure text does not shrink too much
                
                Spacer()
                
                // Conditional display for Accept/Reject or Icon
                if showIcon {
                    VStack {
                        // Clipboard icon with notification bubble (top-right corner)
                        HStack {
                            Spacer()
                            Button(action : {})
                            {
                                ZStack {
                                    Image(systemName: "list.clipboard") // Clipboard icon
                                        .font(.system(size: min(20, geometry.size.width * 0.05)))
                                        .foregroundColor(.gray)
                                    
                                    // Notification bubble
                                    Text("4")
                                        .font(.customfont(.semibold, fontSize: 9))
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(Circle().fill(Color.red))
                                        .offset(x: 7, y: -8)
                                }
                            }
                            .offset(x: geometry.size.width * -(0.04), y: geometry.size.height * -(0.3))
                         
                        }
                    }
                } else {
                    // Use text Accept/Reject
                    Button(action : {}){
                        Text(isAccepted ? "Accept" : "Reject")
                            .font(.customfont(.medium, fontSize: 12)) // Responsive font size
                            .foregroundColor(isAccepted ? .green : .red)
                            .fontWeight(.medium)
                            
                    }.offset(x: geometry.size.width * -(0.04), y: geometry.size.height * -(0.3))
                }
            }
         .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .frame(maxWidth: .infinity, minHeight: 100)
        }
    }
}

#Preview {
    VStack {
        // Preview with the clipboard icon
        OrderCard(isAccepted: true, isOrder: false, showIcon: true)
            .frame(width: 400, height: 120) // Adjust to see the responsive behavior

        // Preview with "Order" and "Accept" text
        OrderCard(isAccepted: true, isOrder: true, showIcon: false)
            .frame(width: 400, height: 120) // Adjust to see the responsive behavior

        // Preview with "Order" and "Reject" text
        OrderCard(isAccepted: false, isOrder: true, showIcon: false)
            .frame(width: 400, height: 120) // Adjust to see the responsive behavior
    }
}
