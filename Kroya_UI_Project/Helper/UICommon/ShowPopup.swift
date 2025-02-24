//
//  ShowPopup.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 24/10/24.
//

import SwiftUI

struct CustomMenuView: View {
    @Binding var showPopup: Bool
    var onUpdate: () -> Void
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                onUpdate() // Trigger the callback for Edit
            }) {
                HStack {
                    Text("Edit")
                        .foregroundStyle(.yellow)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(.yellow)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .contentShape(Rectangle())
            }
            Divider()
            
            Button(action: {
                onDelete() // Trigger the callback for Delete
                showPopup = false
            }) {
                HStack {
                    Text("Delete")
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .contentShape(Rectangle())
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 150)  // You can customize the width here
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    CustomMenuView(showPopup: .constant(true), onUpdate: {}, onDelete: {})
}
