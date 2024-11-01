//
//  AddressRowView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 7/10/24.
//

import SwiftUI

struct AddressRowView: View {
    
    var address: Address
    var onUpdate: () -> Void
    var onDelete: () -> Void
    @State var isShowPopup  : Bool = false
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack{
                        Text(address.addressDetail)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(.black)
                            .opacity(0.6)
                        if isSelected {
                            Text("Default")
                                .font(.customfont(.light, fontSize: 10))
                                .fontWeight(.medium)
                                .foregroundColor(PrimaryColor.normal)
                                .frame(width: 46,height: 19)
                                .background(Color(hex: "#FFFAE6"))
                                .cornerRadius(6)
                        }
                        Spacer()
                    }
                    Text(address.specificLocation)
                        .font(.customfont(.regular, fontSize: 12))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .opacity(0.4)
                        .lineLimit(1)
                }
                Spacer()
                Text(address.tag)
                    .foregroundColor(PrimaryColor.normal)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                Button(action: {
                    isShowPopup.toggle()
                }) {
                    Image("dot")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                .popover(isPresented: $isShowPopup, attachmentAnchor: .point(.topTrailing), arrowEdge: .top) {
                    CustomMenuView(showPopup: $isShowPopup, onUpdate: onUpdate, onDelete: onDelete)
                        .presentationCompactAdaptation(.none)
                }
            }
            .padding(.vertical, 5)
            .padding(.leading,5)
            Divider()
        }
   
        .onTapGesture {
            // Handle tap if needed
        }
    }
}
