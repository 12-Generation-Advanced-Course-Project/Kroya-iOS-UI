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
            Menu{
                Button(){
                    // Action for button
                } label: {
                    Label("Edit", systemImage: "pencil")
                }

                Button(role: .destructive){
                    // Action for button
                } label:{
                    Label("Delete", systemImage: "trash.fill")
                }

            } label: {
                Image("ellipsis")
                    .padding(.trailing, 20)
            }
        }
    }
}
#Preview {
    EditDropDownButton()
}
