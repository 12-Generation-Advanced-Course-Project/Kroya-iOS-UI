//
//  FillPasswordScreen.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 2/10/24.
//

import SwiftUI


struct FillPasswordScreen: View {
    @Environment(\.dismiss) var dismiss
    @State var password: String = ""
    @State var isPasswordVisible: Bool = false
    @EnvironmentObject var userStore: UserStore
    @ObservedObject var authVM: AuthViewModel
    var body: some View {
        ZStack{
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
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
                    PasswordField(iconName: "lock", placeholder: "Input your password", text: $password, isSecure: !isPasswordVisible,frameWidth: .infinity)
                  
                    Text("Forget Password?")
                        .foregroundStyle(.black.opacity(0.8))
                        .font(.customfont(.semibold, fontSize: 14))
                        .underline()
                        .frame(maxWidth: .infinity,alignment: .trailing)
                        .padding(.top,5)
                    
                }
                .frame(maxWidth: .infinity,alignment: .center)
                .padding()
                Spacer().frame(height: 20)
                Button(action: {
                  
                    authVM.loginAccountEmail(email: userStore.user?.email ?? "", password: "hengheng")
                }) {
                    Text("Login")
                        .font(.customfont(.semibold, fontSize: 18))
                        .frame(width: .screenWidth * 0.85)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                NavigationLink(destination: MainScreen().navigationBarBackButtonHidden(true),isActive: $authVM.isLoggedIn) {
                    EmptyView()
                  }.hidden()
                
                Spacer()
            }
            .navigationBarHidden(true)
            if authVM.isLoading{
                ProgressIndicator()
            }
        }
    }
}


