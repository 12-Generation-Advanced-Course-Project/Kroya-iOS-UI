import SwiftUI

struct Notification: View {
    
    @Environment(\.dismiss) var dismiss
    let notification = [1, 2, 3, 4, 5]
    

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Today")
                    .font(.customfont(.semibold, fontSize: 16))
                    .foregroundStyle(.black)) {
                        ForEach(notification, id: \.self) { notification in
                            NotificationComponent(notificationType: 1)
                                .listRowSeparator(.hidden)
                        }
                    }
                
                Section(header: Text("This Week")
                    .font(.customfont(.semibold, fontSize: 16))
                    .foregroundStyle(.black)) {
                        ForEach(notification, id: \.self) { notification in
                            NotificationComponent(notificationType: 2)
                                .listRowSeparator(.hidden)
                        }
                    }
            }
            .listStyle(PlainListStyle())
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.black)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Notification")
                                .font(.customfont(.semibold, fontSize: 25))
                                .foregroundStyle(.black)
                            Group{
                                Text("You have ")
                                + Text("\(notification.count) Notifications ")
                                    .foregroundStyle(.yellow)
                                + Text("today")
                            }
                            .font(.customfont(.regular, fontSize: 12))
                            .foregroundStyle(.black.opacity(0.6))
                        }
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Notification()
}
