import SwiftUI

struct DynamicPopupMessage: View {
    var title: String // Title of the popup
    var message: String // Message body
    var iconName: String // Name of the image or SF Symbol
    var iconColor: Color = .green // Icon color
    var backgroundColor: Color = .white // Background color of the popup
    var titleColor: Color = .green // Title text color
    var messageColor: Color = .gray // Message text color
    var duration: Double = 2.0 // Duration for the popup to display
    
    @Binding var isPresented: Bool // Binding to show or hide the popup

    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 10) {
                    Image(systemName: iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50) // Static icon size
                        .foregroundColor(iconColor)

                    Text(LocalizedStringKey(title))
                        .font(.system(size: 20, weight: .bold)) // Static title font size
                        .foregroundColor(titleColor)

                    Text(LocalizedStringKey(message))
                        .font(.system(size: 14)) // Static message font size
                        .foregroundColor(messageColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20) // Static horizontal padding
                }
                .frame(width: 300, height: 150) // Static popup size
                .background(backgroundColor)
                .cornerRadius(20) // Static corner radius
                .onAppear {
                    // Automatically dismiss after `duration` seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        isPresented = false
                    }
                }
            }
        }
    }
}
