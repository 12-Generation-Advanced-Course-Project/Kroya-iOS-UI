



import SwiftUI


struct StepEntryView: View {
    @Binding var cookingStep: CookingStep
    let index: Int
    let onDelete: () -> Void
    
    @State private var showError: Bool = false
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack {
                        Text("\(index + 1)")
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundStyle(.white)
                            .frame(width: 30, height: 30)
                            .background(Circle().fill(Color.gray))
                        Image("ico_move")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(hex: "#D0DBEA"))
                        Spacer().frame(height: 10)
                    }
                    
                    ZStack(alignment: .trailing) {
                        TextField("Enter ingredients", text: Binding(
                            get: { cookingStep.description },
                            set: { newValue in
                                cookingStep.description = newValue
                                // Hide error message if the user enters text
                                if !newValue.isEmpty {
                                    showError = false
                                }
                            }
                        ), axis: .vertical)
                        .textFieldStyle(PlainTextFieldStyle())
                        .multilineTextAlignment(.leading)
                        .padding(10)
                        .frame(minHeight: 100, alignment: .topLeading)
                        .font(.customfont(.medium, fontSize: 15))
                        .foregroundStyle(.black.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
                        )
                        
                        Button(action: {
                            onDelete()
                            showError = false // Reset error when item is deleted
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .foregroundStyle(.black)
                                .padding(.bottom, 50)
                                .padding(.trailing, 10)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.trailing,1)
                }
                
                // Validation error message
                if showError && cookingStep.description.isEmpty {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("Please write a description for this step.")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    .padding(.horizontal)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .onChange(of: cookingStep.description) { newValue in
            // Hide the error if a valid input is provided
            if !newValue.isEmpty {
                showError = false
            }
        }
    }
    
    // Function to show the error when "Next" is pressed without input
    func validateStep() {
        showError = cookingStep.description.isEmpty
    }
}
