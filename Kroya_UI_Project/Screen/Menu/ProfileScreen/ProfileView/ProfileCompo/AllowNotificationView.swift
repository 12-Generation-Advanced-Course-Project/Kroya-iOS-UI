//
//  AllowNotificationView.swift
//  Kroya_UI_Project
//
//  Created by PVH_003 on 15/10/24.
//

import SwiftUI

struct AllowNotificationView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
       
            VStack{
                VStack{
                    Group{
                        Text("Do you want to turn")
                        Text("on Notification?")
                    }
                    .font(.customfont(.semibold, fontSize: 24))
                    Spacer()
                    Image("PushNotification")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity,maxHeight: 253)
                    Spacer()
                }
                VStack{
                    CustomButton(title: "Allow Notification", action: {print("Button Tap!")}, backgroundColor: .yellow, frameWidth: .infinity)
                    CustomButton(title: "Not Now", action: {print("Button Tap!")}, backgroundColor: .clear, textColor: .yellow)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
        
    }
}

#Preview {
    AllowNotificationView()
}
