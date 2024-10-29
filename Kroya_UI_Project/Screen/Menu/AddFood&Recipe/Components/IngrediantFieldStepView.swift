



import SwiftUI

struct Step: Identifiable, Codable {
    var id = UUID()
    var description: String
}

struct StepEntryView: View {
    @Binding var step: Step
    let index: Int
    let onEdit: () -> Void
    let onDelete: () -> Void
    
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
                            .foregroundColor(.gray)
                            .padding(.bottom, 20)
                        Spacer().frame(height: 10)
                    }
                    
                    ZStack(alignment: .trailing) {
                        // Multi-line TextField
                        TextField(LocalizedStringKey("Enter ingredients"), text: $step.description, axis: .vertical)
                            .textFieldStyle(PlainTextFieldStyle())
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .frame(minHeight: 100, alignment: .topLeading)  // Adjust for multi-line height
                            .font(.customfont(.medium, fontSize: 15))
                            .foregroundStyle(.black.opacity(0.6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
                            )
                        
                        // Dropdown menu for Edit and Delete options, placed inside the text field
                        EditDropDownButton(onEdit: onEdit, onDelete: onDelete)
                            .padding(.bottom, .screenHeight * 0.08)
                    }
                    .frame(maxWidth: .infinity)
                }
                if step.description == ""{
                    HStack{
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text(LocalizedStringKey("description cannot be empty"))
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
