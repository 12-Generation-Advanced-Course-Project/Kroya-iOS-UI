//
//  AppSettingView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 6/10/24.
//

import SwiftUI

struct AppSettingView: View {
    
    var imageName: String
    var title: String
    var iconName: String
    
    var body: some View {
        HStack(spacing: 10) {
            
            HStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.customfont(.medium, fontSize: 16))
            }.padding(.horizontal,10)
            
            Spacer()
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .padding(.trailing,8)
        }
        .frame(width: .screenWidth * 0.9, height: .screenHeight * 0.05)
        .background(Color(hex: "#F4F5F7"))
        .cornerRadius(15)
        

    }
}

#Preview {
    VStack {
        AppSettingView(
            imageName: "VectorLocation", title: "Change Location", iconName: "Rightarrow"
        )
        AppSettingView(
            imageName: "notification 1", title: "Notifications", iconName: "Rightarrow"
        )
        AppSettingView(
            imageName: "languageIcon", title: "Language", iconName: "Rightarrow"
        )
    }
}
