//
//  IngrediantFieldStepView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 11/10/24.
//


import SwiftUI

struct Step: Identifiable {
    var id = UUID()
    var description: String
}

struct StepEntryView: View {
    @Binding var step: Step // Binding to the step data
    var index: Int
    
    var body: some View {
        HStack {
            Image("ico_move") // Placeholder icon for potential future use
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.gray)
                .padding(.leading, 10)
            
            TextField("Enter step description", text: $step.description)
                .padding(.vertical, 15)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 10)
                .frame(width: .screenWidth * 0.80)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
                )
                .font(.customfont(.medium, fontSize: 15))
                .foregroundStyle(.black.opacity(0.6))
                .cornerRadius(15)
        }
        .padding(.vertical, 5)
    }
}
