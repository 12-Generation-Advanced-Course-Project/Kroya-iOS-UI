//
//  InputFildProfile.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/15/24.



import SwiftUI

struct Text_field: View {
    @Binding var text: String
    var label: String
    var framHeight : CGFloat = 60
    var backgroundColor: Color = .white
    var fontcolor: Color = .black
    var body: some View {
        HStack {
            Text(label)
                .opacity(0.6)
            
            Spacer().frame(width: 20)

            TextField("", text : $text)
                .opacity(0.9)
                .foregroundStyle(fontcolor)
            
        }.font(.customfont(.medium, fontSize: 18))
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor).shadow(radius: 1)
        )
    }
}

#Preview {
    Text_field(text: .constant(""), label: "Full name:")
}
