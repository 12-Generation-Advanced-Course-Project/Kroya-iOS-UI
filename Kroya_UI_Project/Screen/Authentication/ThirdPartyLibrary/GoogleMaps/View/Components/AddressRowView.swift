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
                    Text(address.addressDetail)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.black)
                        .opacity(0.6)
                    Text(address.specificLocation)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .opacity(0.4)
                        .lineLimit(1)
                }
                Spacer()
                Text(address.tag)
                    .foregroundColor(PrimaryColor.normal)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                Button(action: {
                    print("Button tapped")
                    isShowPopup.toggle()
                }) {
                    Image("dot")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                .popover(isPresented: $isShowPopup ,attachmentAnchor: .point(.topTrailing), arrowEdge: .top) {
                    CustomMenuView(showPopup: $isShowPopup, onUpdate: onUpdate, onDelete: onDelete)
                        .presentationCompactAdaptation(.none)
                }

            }
            .padding(.vertical, 5)
            Divider()
        }
    }
}

#Preview {
    AddressRowView(
        address: Address(id: 1, addressDetail: "HRD Center, St232", specificLocation: "Russian federation blvd. (#110)", tag: "Office"),
        onUpdate: { print("Update Address") },
        onDelete: { print("Delete Address") }
    )
}
