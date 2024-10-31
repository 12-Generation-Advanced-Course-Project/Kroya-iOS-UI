import SwiftUI

struct NotificationItem: Identifiable {
    let id = UUID()
    var image: String
    var name: String
    var notificationType: Int
    var time: String
    var seen: Bool // New property to indicate if the notification has been seen
}

struct Notification: View {
    @Environment(\.dismiss) var dismiss
    // State to control programmatic navigation
       @State private var selectedNotification: NotificationItem? = nil
    @State private var notificationsNew  = [
        NotificationItem(image: "Songvak", name: "Songvak", notificationType: 1, time: "14 m ago", seen: false),
        NotificationItem(image: "SomlorKari", name: "SomlorKari", notificationType: 2, time: "30 m ago", seen: false),
        NotificationItem(image: "ahmok", name: "Amok Fish", notificationType: 3, time: "1 h ago", seen: false),
        NotificationItem(image: "food5", name: "Amok Fish", notificationType: 4, time: "2 h ago", seen: true)
    ]

    @State private var notificationsNewOlder = [
        NotificationItem(image: "food1", name: "SomlorKari", notificationType: 1, time: "11/10/2024", seen: true),
        NotificationItem(image: "food2", name: "SomlorMju", notificationType: 2, time: "11/10/2024", seen: true),
        NotificationItem(image: "food3", name: "Amok Fish", notificationType: 3, time: "10/10/2024", seen: true),
        NotificationItem(image: "food4", name: "SomlorMju", notificationType: 4, time: "10/10/2024", seen: true)
    ]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("New")
                    .font(.customfont(.semibold, fontSize: 16))
                    .foregroundStyle(.black)) {
                        ForEach($notificationsNew) { $notification in
                //Button for navigate to the Food detail
                            Button(action: {
                                selectedNotification = notification
                                notification.seen = true // Mark as seen /
                            })
                            {
                                NotificationComponent(
                                    image: notification.image,
                                    name: notification.name,
                                    notificationType: notification.notificationType,
                                    time: notification.time,
                                    seen: notification.seen
                                )
                            }
                        .frame(maxWidth: .infinity, alignment: .center) // Center content in the row
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets()) // Remove default padding
                    }
                    }
                Section(header: Text("Older")
                    .font(.customfont(.semibold, fontSize: 16))
                    .foregroundStyle(.black)) {
                    ForEach($notificationsNewOlder) { $notification in
        //Button for navigate to the Food detail
                        Button(action: {
                            selectedNotification = notification
                            notification.seen = true
                        }){
                            NotificationComponent(
                                image: notification.image,
                                name: notification.name,
                                notificationType: notification.notificationType,
                                time: notification.time,
                                seen: notification.seen
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .center) // Center content in the row
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets()) // Remove default padding
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
                            Text(LocalizedStringKey("Notification"))
                                .font(.customfont(.semibold, fontSize: 20))
                                .foregroundStyle(.black)
                            HStack {
                                Text(LocalizedStringKey("You have"))
                                Text("\(notificationsNew.count) Notifications")
                                    .foregroundStyle(.yellow)
                                Text(LocalizedStringKey("Today"))
                            }
                            .font(.customfont(.regular, fontSize: 12))
                            .foregroundStyle(.black.opacity(0.6))
                        }
                    }
                }
            }
            
            // Programmatic navigation to FoodDetailView
            // Programmatic navigation to FoodDetailView
            .background(
                NavigationLink(
                    destination: FoodDetailView(
                        theMainImage: selectedNotification?.image ?? "Songvak",
                        subImage1: "ahmok",
                        subImage2: "brohok",
                        subImage3: "SomlorKari",
                        subImage4: "Songvak",
                        showOrderButton: false, // Hide Order button when accessed from Notification
                        notificationType: selectedNotification?.notificationType // Pass notificationType here
                    ),
                    isActive: Binding(
                        get: { selectedNotification != nil },
                        set: { if !$0 { selectedNotification = nil } }
                    )
                ) {
                    EmptyView()
                }
            )

        }
        .navigationBarBackButtonHidden(true)
    }
}

