//
//  PopupMessage.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 23/10/24.
//

import SwiftUI

struct PopupMessage: View {
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
                Text("Successfully")
                    .font(.customfont(.bold, fontSize: 20))
                    .foregroundStyle(.green)
                Spacer().frame(height: 10)
                Text("Your account have been created successfully")
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

#Preview {
    PopupMessage()
}
