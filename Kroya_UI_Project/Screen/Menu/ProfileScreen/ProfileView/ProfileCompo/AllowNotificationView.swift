//
//  AllowNotificationView.swift
//  Kroya_UI_Project
//
//  Created by PVH_003 on 15/10/24.
//

import SwiftUI

struct AllowNotificationView: View {
    var localNotification = LocalNotificationManager.shared
    @Environment(\.dismiss) var dismiss
    @State var seletedDate = Date()
    @State private var notificationAllowed = false
    var body: some View {
        VStack {
            VStack {
                HStack(alignment: .center) {
                    Text("Do you want to turn on\nNotification?")
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity)
                }
                .frame(minHeight: 40)
                .padding()
                .customFontSemiBoldLocalize(size: 24)
                Spacer()
                Image("PushNotification")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 253)
                Spacer()
            }
            VStack {
                CustomButton(title: LocalizedStringKey("Allow Notification"), action: {    LocalNotificationManager.shared.askForNotificationPermission()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        LocalNotificationManager.shared.sendImmediateNotification()
                    }
                    
                }, backgroundColor: .yellow,frameWidth: .screenWidth * 0.85)
                CustomButton(title: LocalizedStringKey("Not Now"), action: { dismiss() }, backgroundColor: .clear, textColor: .yellow)
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
