//
//  ClientIdTextField.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/18/24.
//


import SwiftUI

struct ClientIdTextField: View {
    var iconName: String
    var placeholder: String
    @Binding var text: String
    @State var isSecure: Bool = true
    var iconColor: Color = .gray
    var backgroundColor: Color = Color(UIColor.systemGray6)
  //  var frameHeight: CGFloat = 60
    var cornerRadius: CGFloat = 10
    //var frameWidth:CGFloat = 300

    @State private var isPasswordVisible: Bool = false

    // Function to check if the icon exists in SF Symbols
    private func isSystemIcon(_ name: String) -> Bool {
        return UIImage(systemName: name) != nil
    }

    var body: some View {
        HStack {
            if isSystemIcon(iconName) {
                Image(systemName: iconName)
                    .foregroundColor(iconColor)
                    .padding(.leading, 20)
            } else {
                Image(iconName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(iconColor)
                    .padding(.leading, 20)
            }
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(.custom("Inter", size: 18))
                    .padding(.vertical, 20)
                    .padding(.horizontal, 5)
            } else {
                TextField(placeholder, text: $text)
                    .font(.custom("Inter", size: 18))
                    .padding(.vertical, 20)
                    .padding(.horizontal, 5)
            }
            
        }
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .frame(maxWidth: .infinity, maxHeight: 60) 
    }
}

#Preview {
    ClientIdTextField(iconName: "lock",
                      placeholder: "Input your password",
                      text: .constant(""),
                      isSecure: true)
}

