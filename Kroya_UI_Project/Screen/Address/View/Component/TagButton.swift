import SwiftUI

struct TagButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .medium))
                }
                Text(title)
                    .foregroundColor(isSelected ? .white : .black)
                    .font(.system(size: 13, weight: .medium))
            }
            .padding(.horizontal, 13)
            .padding(.vertical, 8)
            .background(isSelected ? Color.yellow : Color.clear)
            .cornerRadius(7)
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(isSelected ? Color.clear : Color.gray, lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.3), value: isSelected)
        }
    }
}

#Preview {
    TagButton(title: "Home", isSelected: false) {
        // Action
    }
}
