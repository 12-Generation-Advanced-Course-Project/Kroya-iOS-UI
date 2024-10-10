



import SwiftUI

struct ChipCheckView: View {
    @Binding var isChecked: Bool
    var name: String
    
    var body: some View {
        HStack {
            if isChecked {
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
            }
            Text(name)
                .font(.customfont(.medium, fontSize: 14))
                .foregroundColor(.black)
                .lineLimit(1) // Limit to a single line to prevent wrapping
                .padding(.leading, 5) // Add padding between checkmark and text
        }
        .padding(10)
        .background(isChecked ? PrimaryColor.lightActive : .white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(isChecked ? .clear : .black, lineWidth: 1)
        )
        .fixedSize(horizontal: true, vertical: false)
        .animation(.easeInOut(duration: 0.3), value: isChecked)
    }
}

#Preview {
    ChipCheckView(isChecked: .constant(false), name: "Hard")
}


