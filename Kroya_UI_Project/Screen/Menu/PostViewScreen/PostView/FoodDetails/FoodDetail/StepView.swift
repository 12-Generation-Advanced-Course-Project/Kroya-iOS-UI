//
//  StepView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/23/24.
//

import SwiftUI

struct StepView: View {
    @State private var count = 0
    @State private var currentStep = 1
    // Step details
    let steps = [
        "Cut the fish into bite sized pieces and set aside.",
        "Clean and slice the vegetables..",
        "In a large skillet, heat the curry seed oil, amok paste, shrimp paste, and coconut milk. Heat thoroughly, cooking until fragrant."
    ]
    var body: some View {
        GeometryReader{ geometry in
            VStack (alignment:.leading, spacing: 10){
                HStack {
                    Text("Steps")
                        .font(.system(size: 17))
                        .bold()
                    
                    Spacer()
                    
                    // Button to go to the previous step
                    Button(action: {
                        if currentStep > 1 {
                            currentStep -= 1
                        }
                    }) {
                        Circle()
                            .stroke(Color(hex: "FECC03"), lineWidth: 2)
                            .frame(width: geometry.size.width * 0.08)
                            .overlay(
                                Image(systemName: "arrow.backward.to.line")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.05)
                                    .foregroundStyle(Color(hex: "FECC03"))
                                    .clipShape(Circle())
                            )
                    }
                    // Button to go to the next step
                    Button(action: {
                        if currentStep < steps.count {
                            currentStep += 1
                        }
                    }) {
                        Circle()
                            .stroke(Color(hex: "FECC03"), lineWidth: 2)
                            .frame(width: geometry.size.width * 0.08)
                            .overlay(
                                Image(systemName: "arrow.right.to.line")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.05)
                                    .foregroundStyle(Color(hex: "FECC03"))
                                    .clipShape(Circle())
                            )
                    }
                }
                
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(Color(hex: "#2E3E5C"))
                        .frame(width: geometry.size.width * 0.074)
                        .overlay(
                            Text("\(currentStep)")
                                .font(.customfont(.bold, fontSize: 14))
                                .foregroundColor(Color.white)
                        )
                    // Display step detail based on the current step
                    Text(steps[currentStep - 1])
                        .font(.system(size: 16))
                }
            }
        }
    }
}

//#Preview {
//    StepView()
//}
