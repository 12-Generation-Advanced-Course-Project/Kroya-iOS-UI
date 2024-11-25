//
//
//import SwiftUI
//
//struct Notification: View {
//
//    @Environment(\.dismiss) var dismiss
//    @State private var notifications: [NotificationModel] = []
//    @State private var selectedNotification: NotificationModel?
//    //        @State private var notificationsNew  = [
//    //            NotificationItem(image: "Songvak", name: "Songvak", notificationType: 1, time: "14 m ago", seen: false),
//    //            NotificationItem(image: "SomlorKari", name: "SomlorKari", notificationType: 2, time: "30 m ago", seen: false),
//    //            NotificationItem(image: "ahmok", name: "Amok Fish", notificationType: 3, time: "1 h ago", seen: false),
//    //            NotificationItem(image: "food5", name: "Amok Fish", notificationType: 4, time: "2 h ago", seen: true)
//    //        ]
//    //
//    //        @State private var notificationsNewOlder = [
//    //            NotificationItem(image: "food1", name: "SomlorKari", notificationType: 1, time: "11/10/2024", seen: true),
//    //            NotificationItem(image: "food2", name: "SomlorMju", notificationType: 2, time: "11/10/2024", seen: true),
//    //            NotificationItem(image: "food3", name: "Amok Fish", notificationType: 3, time: "10/10/2024", seen: true),
//    //            NotificationItem(image: "food4", name: "SomlorMju", notificationType: 4, time: "10/10/2024", seen: true)
//    //        ]
//
//    var body: some View {
//        NavigationView {
//            List {
//                Section(header: Text("New")
//                    .font(.customfont(.semibold, fontSize: 16))
//                    .foregroundStyle(.black)) {
//                        ForEach(notifications) { notification in
//                            //Button for navigate to the Food detail
//                            Button(action: {
//                                selectedNotification = notifications
//                                notification.seen = true // Mark as seen /
//                            })
//                            {
//                                Notification()
//                                //                                    NotificationComponent(
//                                //                                        image: notification.image,
//                                //                                        name: notification.name,
//                                //                                        notificationType: notification.notificationType,
//                                //                                        time: notification.time,
//                                //                                        seen: notification.seen
//                                //                                    )
//                            }
//                            .frame(maxWidth: .infinity, alignment: .center) // Center content in the row
//                            .listRowSeparator(.hidden)
//                            .listRowInsets(EdgeInsets()) // Remove default padding
//                        }
//                    }
//                Section(header: Text("Older")
//                    .font(.customfont(.semibold, fontSize: 16))
//                    .foregroundStyle(.black)) {
//                        ForEach(notifications) { $notification in
//                            //Button for navigate to the Food detail
//                            Button(action: {
//                                selectedNotification = notification
//                                notifications.seen = true
//                            }){
//                                Notification()
//                                //                                    NotificationComponent(
//                                //                                        image: notification.image,
//                                //                                        name: notification.name,
//                                //                                        notificationType: notification.notificationType,
//                                //                                        time: notification.time,
//                                //                                        seen: notification.seen
//                                //                                    )
//                            }
//                            .frame(maxWidth: .infinity, alignment: .center) // Center content in the row
//                            .listRowSeparator(.hidden)
//                            .listRowInsets(EdgeInsets()) // Remove default padding
//                        }
//                    }
//            }
//            .listStyle(PlainListStyle())
//            .scrollIndicators(.hidden)
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    HStack {
//                        Button(action: {
//                            dismiss()
//                        }) {
//                            Image(systemName: "arrow.left")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 20, height: 20)
//                                .foregroundStyle(.black)
//                        }
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("Notification")
//                                .font(.custom("HelveticaNeue-Semibold", size: 20))
//                                .foregroundStyle(.black)
//                            HStack {
//                                Text(LocalizedStringKey("You have"))
//                                Text("\(notifications.count) Notifications")
//                                    .foregroundStyle(.yellow)
//                                Text(LocalizedStringKey("Today"))
//                            }
//                            .font(.custom("HelveticaNeue-Regular", size: 12))
//                            .foregroundStyle(.black.opacity(0.6))
//                        }
//                    }
//                }
//            }
//            .background(
//                NavigationLink(
//                    destination:
//                        //                            FoodDetailView(
//                    //                            theMainImage: selectedNotification?.image ?? "Songvak",
//                    //                            subImage1: "ahmok",
//                    //                            subImage2: "brohok",
//                    //                            subImage3: "SomlorKari",
//                    //                            subImage4: "Songvak",
//                    //                            showOrderButton: false,
//                    //                            showPrice: true,
//                    //                            notificationType: selectedNotification?.notificationType // Pass notificationType here
//                    //                        )
//                    EmptyView()
//                    ,
//                    isActive: Binding(
//                        get: { selectedNotification != nil },
//                        set: { if !$0 { selectedNotification = nil} }
//                    )
//                ) {
//                    EmptyView()
//                }
//            )
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
//


import SwiftUI

struct NotificationView: View {
    
    @StateObject private var viewModel = NotificationViewModel() // Initialize the view model
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("New")
                    .font(.custom("HelveticaNeue-Semibold", size: 16))) {
                        ForEach(viewModel.notifications) { notification in
                            NotificationComponent(notification: notification)
                        }
                    }
                
                Section(header: Text("Older")
                    .font(.custom("HelveticaNeue-Semibold", size: 16))) {
                        ForEach(viewModel.notifications) { notification in
                            NotificationComponent(notification: notification)
                        }
                    }
            }
            .listStyle(PlainListStyle())
            
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchNotifications()
            }
        }
    }
}
