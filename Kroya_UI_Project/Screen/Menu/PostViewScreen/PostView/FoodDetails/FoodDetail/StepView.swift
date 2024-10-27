import SwiftUI

struct StepView: View {
    @State private var currentStep = 1
    @Environment(\.dismiss) var dismiss

    // Step details
    let steps = [
        "Cut the fish into bite sized pieces and set aside.",
        "Clean and slice the vegetables.",
        "In a large skillet, heat the curry seed oil, amok paste, shrimp paste, and coconut milk. Heat thoroughly, cooking until fragrant."
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Steps")
                        .font(.system(size: 17))
                        .bold()
                    
                    Spacer()
                    
                    // Button to go to the previous step with animation
                    Button(action: {
                        if currentStep > 1 {
                            withAnimation(.easeInOut) {
                                currentStep -= 1
                            }
                        }
                    }) {
                        Circle()
                            .stroke(Color(hex: "FECC03"), lineWidth: 2)
                            .frame(width: geometry.size.width * 0.06)
                            .overlay(
                                Image(systemName: "arrow.backward.to.line")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.04)
                                    .foregroundStyle(Color(hex: "FECC03"))
                                    .clipShape(Circle())
                            )
                    }
                    
                    // Button to go to the next step with animation
                    Button(action: {
                        if currentStep < steps.count {
                            withAnimation(.easeInOut) {
                                currentStep += 1
                            }
                        }
                    }) {
                        Circle()
                            .stroke(Color(hex: "FECC03"), lineWidth: 2)
                            .frame(width: geometry.size.width * 0.06)
                            .overlay(
                                Image(systemName: "arrow.right.to.line")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.04)
                                    .foregroundStyle(Color(hex: "FECC03"))
                                    .clipShape(Circle())
                            )
                    }
                }
                //.padding(.top,3)
           
                    // TabView for animated step change
                    TabView(selection: $currentStep) {
                        ForEach(1...steps.count, id: \.self) { step in
                            HStack(alignment: .top, spacing: 10) {
                                Circle()
                                    .fill(Color(hex: "#2E3E5C"))
                                    .frame(width: geometry.size.width * 0.074)
                                    .overlay(
                                        Text("\(step)")
                                            .font(.customfont(.bold, fontSize: 14))
                                            .foregroundColor(Color.white)
                                    )
                                // Display step detail based on the current step
                                Text(steps[step - 1])
                                    .font(.system(size: 16))
                             //   Spacer()
                            }
                            .tag(step) // Tag for each step to track the selected Tab
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never)) // Page style without dots
                    //  .frame(height: 100) // Adjust height if needed
                    .disabled(true) // Disable swipe gestures
                }
                
            }
        }
    }


#Preview {
    StepView()
}
