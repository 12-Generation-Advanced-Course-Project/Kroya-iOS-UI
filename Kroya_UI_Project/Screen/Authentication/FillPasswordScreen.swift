//
//  FillPasswordScreen.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 2/10/24.
//

import SwiftUI


struct FillPasswordScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State var password: String = ""
    @State var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Continue with password")
                    .font(.customfont(.semibold, fontSize: 16))
                    .foregroundColor(.black)
                
                Spacer()
                
                Spacer()
                    .frame(width: 24)
            }
            .padding()
            VStack (alignment: .leading){
                Text("Password")
                    .foregroundStyle(.black.opacity(0.8))
                    .font(.customfont(.regular, fontSize: 16)) +
                Text(" *").foregroundStyle(.red)
                PasswordField(iconName: "lock", placeholder: "Input your password", text: $password, isSecure: !isPasswordVisible,frameWidth: .screenWidth * 0.9)
              
                Text("Forget Password?")
                    .foregroundStyle(.black.opacity(0.8))
                    .font(.customfont(.semibold, fontSize: 14))
                    .underline()
                    .padding(.leading,240)
                    .padding(.top,5)
                
            }
            Spacer().frame(height: 20)
            NavigationLink(destination: VerificationCodeView(), label: {
                Text("Login")
                    .font(.customfont(.semibold, fontSize: 18))
                    .frame(width: .screenWidth * 0.822)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
              }
            )
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    FillPasswordScreen()
}
