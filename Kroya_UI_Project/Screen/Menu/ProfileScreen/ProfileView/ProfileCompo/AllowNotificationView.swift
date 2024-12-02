import SwiftUI
import UserNotifications

struct AllowNotificationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var notificationAllowed = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            VStack {
                HStack(alignment: .center) {
                    Text("Do you want to turn on\nNotification?")
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity)
                }
                .frame(minHeight: 40)
                .padding()
                .font(.system(size: 24, weight: .semibold))
                
                Spacer()
                
                Image("PushNotification")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 253)
                
                Spacer()
            }
            VStack {
                // Allow Notification Button
                Button(action: {
                    checkNotificationPermission()
                }) {
                    Text("Allow Notification")
                        .frame(maxWidth: .screenWidth * 0.85, maxHeight: 50)
                        .foregroundColor(.white)
                        .background(Color.yellow)
                        .font(.customfont(.semibold, fontSize: 16))
                        .cornerRadius(10)
                }
                
                // Not Now Button
                Button(action: {
                    dismiss()
                }) {
                    Text("Not Now")
                        .frame(maxWidth: .screenWidth * 0.85, maxHeight: 50)
                        .foregroundColor(.yellow)
                        .background(Color.clear)
                        .cornerRadius(10)
                        .font(.customfont(.semibold, fontSize: 16))
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Notification Disabled"),
                message: Text(alertMessage),
                primaryButton: .default(Text("Go to Settings"), action: openAppSettings),
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
    
    /// Check Current Notification Permission Status
    private func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    // Permission has not been asked before, request it
                    requestNotificationPermission()
                case .denied:
                    // Permission was previously denied
                    alertMessage = "Notifications are disabled. You can enable them in Settings."
                    showAlert = true
                case .authorized, .provisional, .ephemeral:
                    // Permission is already granted
                    alertMessage = "Notifications are already enabled."
                    showAlert = true
                @unknown default:
                    // Handle any unknown cases
                    alertMessage = "Unexpected notification settings state."
                    showAlert = true
                }
            }
        }
    }
    
    /// Request Notification Permissions
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    alertMessage = "Failed to request notifications: \(error.localizedDescription)"
                    showAlert = true
                } else if granted {
                    alertMessage = "Notifications have been enabled."
                    notificationAllowed = true
                    registerForRemoteNotifications()
                } else {
                    alertMessage = "Notifications are disabled. You can enable them in Settings."
                    notificationAllowed = false
                    showAlert = true
                }
            }
        }
    }

    /// Register for Remote Notifications
    private func registerForRemoteNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    /// Redirect to App Settings
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
