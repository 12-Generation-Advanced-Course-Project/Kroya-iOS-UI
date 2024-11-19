//
//  WebillConnectView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/18/24.
//

import SwiftUI

struct WebillConnectView: View {
    @State private var clientId = ""
    @State private var secretId = ""
    @State private var issecretIdVisible = false
    @State private var showMessage = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            VStack(spacing: 15){
                
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 23, height: 23)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                // Title
                Image("webill365_logo")
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width: 119, height: 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                HStack{
                    Text(LocalizedStringKey("Connect to WeBill365 account for e-payment"))
                        .font(.customfont(.medium, fontSize: 15)).padding([.bottom, .top], 5)
                        .foregroundStyle(Color(hex: "#737A86"))
                    Spacer()
                    
                }
                
                HStack{
                    Text(LocalizedStringKey("Client ID"))
                        .font(.customfont(.medium, fontSize: 14))
                        .foregroundStyle(Color(hex: "#0A0019")).padding(.top, 15)
                        .opacity(0.7)
                    Spacer()
                }
                
                ClientIdTextField(
                    iconName: "lock",
                    placeholder: "89f23e528596313390c...",
                    text: $clientId,
                    isSecure: false)
                HStack{
                    Text(LocalizedStringKey("Secret ID"))
                        .font(.customfont(.medium, fontSize: 14))
                        .foregroundStyle(Color(hex: "#0A0019")).padding(.top, 10)
                        .opacity(0.7)
                    Spacer()
                }
                
                PasswordField(
                    iconName: "lock",
                    placeholder: "89f23e528596313390c...",
                    text: $secretId,
                    isSecure: true,
                    frameWidth: .screenWidth * 0.9
                )
                Spacer()
                CustomButton(title: "Save", action: {
                    showMessage = true
                    
                    // Dismiss the message after 0.80 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showMessage = false
                        dismiss()
                    }
                }, backgroundColor: PrimaryColor.normal, frameHeight: 55, frameWidth: UIScreen.main.bounds.width * 0.9)
                
            }  .navigationBarHidden(true)
                .padding(.horizontal, 20)
            
            if showMessage {
                SuccessPopup()
                    .transition(.scale)
            }
        }
    }
}

#Preview {
    WebillConnectView()
}
