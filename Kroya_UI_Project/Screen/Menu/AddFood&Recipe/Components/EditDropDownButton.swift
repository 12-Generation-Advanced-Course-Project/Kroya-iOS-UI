//
//  EditDropDownButton.swift
//  Kroya_UI_Project
//
//  Created by PVH_003 on 16/10/24.
//

import SwiftUI

struct EditDropDownButton: View {
    var body: some View {
        VStack{
            HStack{
                Image("edit")
                    
                Spacer()
                Text("Edit")
                    .foregroundColor(Color(red: 0.18, green: 0.579, blue: 0.114))
            }
        }
        .padding()
        .background(Color.black.opacity(0.2))
    }
}

#Preview {
    EditDropDownButton()
}
