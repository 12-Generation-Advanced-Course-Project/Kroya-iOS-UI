



import SwiftUI

struct ChipCheckView: View {
    var text: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        HStack {
            HStack(spacing: 4) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                        .transition(.scale) // Apply scale transition
                }

                Text(text)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? PrimaryColor.lightActive : Color.white)
            .font(.customfont(.medium, fontSize: 14))
            .foregroundColor(.black)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(isSelected ? Color.clear : Color.black, lineWidth: 1)
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    action()
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}



