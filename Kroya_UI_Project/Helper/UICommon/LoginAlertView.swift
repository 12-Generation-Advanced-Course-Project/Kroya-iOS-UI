//
//  LoginAlertView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 12/11/24.
//

import SwiftUI

struct LoginAlertView: View {
    var onCancel: () -> Void
    var onLogin: () -> Void
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment:.leading,spacing: 10) {
                Text("Login alert !")
                    .customFontBoldLocalize(size: 16)
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                Text("If you want to access to any destination, please tap OK to login to your account.")
                    .customFontMediumLocalize(size: 15)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 10)
                Spacer().frame(height: 20)
                HStack(spacing: 10) {
                  
                    Button(action: {
                        onCancel()
                    }) {
                        Text("Cancel")
                            .customFontSemiBoldLocalize(size: 15)
                            .foregroundColor(.black)
                            .frame(width: 85,height: 45)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        onLogin()
                    }) {
                        Text("OK")
                            .customFontSemiBoldLocalize(size: 15)
                            .foregroundColor(.white)
                            .frame(width: 85,height: 45)
                            .background(PrimaryColor.normal)
                            .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity,alignment: .trailing)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding(.horizontal, 15)
        }
    }
}


//
//  LoginAlertView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 12/11/24.
//

import SwiftUI

struct WeBillDisconnect: View {
    var onCancel: () -> Void
    var onYes: () -> Void
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment:.leading,spacing: 10) {
                Text("Disconnect alert !")
                    .customFontBoldLocalize(size: 16)
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                Text("Are you sure to disconnect account from WeBill?")
                    .customFontMediumLocalize(size: 15)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 10)
                Spacer().frame(height: 20)
                HStack(spacing: 10) {
                  
                    Button(action: {
                        onCancel()
                    }) {
                        Text("Cancel")
                            .customFontSemiBoldLocalize(size: 15)
                            .foregroundColor(.black)
                            .frame(width: 85,height: 45)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        onYes()
                    }) {
                        Text("Yes")
                            .customFontSemiBoldLocalize(size: 15)
                            .foregroundColor(.white)
                            .frame(width: 85,height: 45)
                            .background(PrimaryColor.normal)
                            .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity,alignment: .trailing)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding(.horizontal, 15)
        }
    }
}
