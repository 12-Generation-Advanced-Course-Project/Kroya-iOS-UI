//
//  CreatePasswordStatic.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 3/11/24.
//

import SwiftUI

struct CreatePasswordStatic: View {
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible1 = false
    @State private var isPasswordVisible2 = false
    @State private var errorMessage = ""
    @State private var showPopupMessage = false
    @Environment(\.dismiss) var dismiss
    @State private var isNavigating = false
    @Binding var lang: String

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                // Custom Back Button
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                
                // Title
                Text("Create new password")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                // New Password and Confirm Password Fields
                VStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("New password ") + Text("*").foregroundStyle(.red)
                        PasswordField(
                            iconName: "lock",
                            placeholder: "Input your password",
                            text: $password,
                            isSecure: !isPasswordVisible1,
                            frameWidth: .infinity
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Confirm new password ") + Text("*").foregroundStyle(.red)
                        PasswordField(
                            iconName: "lock",
                            placeholder: "Confirm your password",
                            text: $confirmPassword,
                            isSecure: !isPasswordVisible2,
                            frameWidth: .infinity
                        )
                    }
                    
                    // Error message display
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("")
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 6)
                
                // CREATE PASSWORD Button
                Button(action: {
                    if validatePassword() {
                        // Simulate a successful password creation
                        showPopupMessage = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showPopupMessage = false
                            isNavigating = true
                        }
                    }
                }) {
                    Text("CREATE PASSWORD")
                        .font(.customfont(.semibold, fontSize: 16))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
          
            if showPopupMessage {
                PopupMessage()
                    .transition(.scale)
            }
            
            NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true), isActive: $isNavigating) {
                EmptyView()
            }
            .hidden()

        }
        .navigationBarHidden(true)
       // .navigationBarBackButtonHidden(true)
      
    }
    
    // Password validation logic
    func validatePassword() -> Bool {
        guard !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in both fields."
            return false
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return false
        }
        guard password.count >= 8 else {
            errorMessage = "Password should be at least 8 characters."
            return false
        }
        
        errorMessage = ""
        return true
    }
}

