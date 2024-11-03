//
//  PopupMessage.swift
//  Kroya_UI_Project
//
//  Created by PVH_003 on 1/11/24.
//


import SwiftUI

struct SuccessPopup :View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Image("SuccessCheck")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50, alignment: .center
                    )
                Text(LocalizedStringKey("Successfully"))
                    .font(.customfont(.bold, fontSize: 20))
                    .foregroundStyle(.green)
                Spacer().frame(height: 10)
                Text(LocalizedStringKey("Your account have connected with Webill365 successfully"))
                    .font(.customfont(.regular, fontSize: 12))
                    .foregroundStyle(.gray)
            }
            .frame(minWidth: .screenWidth * 0.7,maxHeight: 150)
            .padding(.horizontal,30)
            .background(.white)
            .cornerRadius(24)
        }
    }
}
