//
//  PasswordField.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/15/24.
//

import SwiftUI

struct PasswordFieldd: View {
    @Binding var password: String
    var backgroundColor: Color = .white
    var label: String

    var body: some View {
        HStack {
            Text(label)
                .font(.customfont(.medium, fontSize: 18))
                .opacity(0.6)
            
            Spacer().frame(width: 20)

            // Display the password as asterisks
            Text(String(repeating: "*", count: password.count))
                .font(.customfont(.medium, fontSize: 18))
                .foregroundColor(Color.black.opacity(0.84))
                .lineLimit(1)

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
                .shadow(radius: 1)
        )
    }
}
