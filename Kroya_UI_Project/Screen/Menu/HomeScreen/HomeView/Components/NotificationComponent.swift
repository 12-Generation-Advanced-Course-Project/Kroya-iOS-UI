//
//  AcceptedOrder.swift
//  Kroya_UI_Project
//
//  Created by PVH_003 on 9/10/24.
//

import SwiftUI

struct OrderAccepted: View {
    
    var name = "នំប៉័ងខ្ទះដែក"
    
    var body: some View {
        HStack{
            Image("KorkoFood")
                .resizable()
                .scaledToFit()
//                .cornerRadius(10)
                .frame(width: 50,height: 50)
             
            VStack(alignment: .leading){
                Text("\(name) accepted order,")
                    .font(.customfont(.medium, fontSize: 12))
                + Text(" please be patient and wait for merchant to prepare meal.")
                    .font(.customfont(.medium, fontSize: 12))
                    .foregroundStyle(.black .opacity(0.6))
                Text("15 m ago")
                    .font(.customfont(.regular, fontSize: 10))
                    .foregroundStyle(.black .opacity(0.6))
            }
        }
        Divider()
    }
}
#Preview {
    OrderAccepted()
}
