//
//  PasswordField.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/15/24.
//

import SwiftUI

struct PasswordFieldd: View {
    @Binding var password: String
    @State private var isSecure: Bool = true
    var label: String
    
    var body: some View {
        HStack {
           
            Text(label)
                .font(.customfont(.medium, fontSize: 18))
                .opacity(0.6)
            
            Spacer().frame(width: 20)

          
            if isSecure {
                SecureField("", text: $password)
                    .font(.customfont(.medium, fontSize: 18))
                    .foregroundColor(Color.black.opacity(0.84))
            } else {
                TextField("", text: $password)
                    .font(.customfont(.medium, fontSize: 18))
                    .foregroundColor(Color.black.opacity(0.84))
            }
            
            Spacer()
            
           
            Button(action: {
                isSecure.toggle()
            }) {
                Image(systemName: isSecure ?  "eye.fill" : "eye.slash.fill")
                    .foregroundColor(Color.gray)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#F4F5F7"))
                .shadow(radius: 1)
        )
    }
}

#Preview {
    PasswordFieldd(password: .constant("password123"), label: "Password")
}

