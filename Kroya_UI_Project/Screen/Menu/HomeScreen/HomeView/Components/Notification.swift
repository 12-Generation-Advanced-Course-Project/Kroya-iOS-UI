//import SwiftUI
//
//struct Notification: View {
//
//    @Environment(\.dismiss) var dismiss
//    let notification = [1, 2, 3, 4, 5]
//
//
//    var body: some View {
//        NavigationView {
//            List {
//                Section(header: Text("New")
//                    .font(.customfont(.semibold, fontSize: 16))
//                    .foregroundStyle(.black)) {
//                        ForEach(notification, id: \.self) { notification in
//                            NotificationComponent(notificationType: 1)
//                                .listRowSeparator(.hidden)
//                        }
//                    }
//
//                Section(header: Text("Old")
//                    .font(.customfont(.semibold, fontSize: 16))
//                    .foregroundStyle(.black)) {
//                        ForEach(notification, id: \.self) { notification in
//                            NotificationComponent(notificationType: 2)
//                                .listRowSeparator(.hidden)
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
//                            Text(LocalizedStringKey("Notification"))
//                                .font(.customfont(.semibold, fontSize: 20))
//                                .foregroundStyle(.black)
//                            Group{
//                                //                                Text(LocalizedStringKey("You have "))
//                                //                                + Text(LocalizedStringKey("\(notification.count) Notifications "))
//                                //                                    .foregroundStyle(.yellow)
//                                //                                + Text(LocalizedStringKey("today"))
//                                HStack{
//                                    Text(LocalizedStringKey("You have"))
//                                    Text(LocalizedStringKey("\(notification.count) Notification"))
//                                        .foregroundStyle(.yellow)
//                                    Text(LocalizedStringKey("Now"))
//
//                                }
//                            }
//                            .font(.customfont(.regular, fontSize: 12))
//                            .foregroundStyle(.black.opacity(0.6))
//                        }
//                    }
//                }
//            }
//        }.navigationBarBackButtonHidden(true)
//    }
//}
//
//#Preview {
//    Notification()
//}


import SwiftUI

struct Notification: View {
    @State var isNavigate:Bool = false
    @Environment(\.dismiss) var dismiss
    @State private var notifications: [NotificationModel] = [
        NotificationModel(id: UUID(), title: "New Notification 1", isClicked: false),
        NotificationModel(id: UUID(), title: "New Notification 1", isClicked: false),
        NotificationModel(id: UUID(), title: "New Notification 1", isClicked: true)
    ]

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("New")
                    .font(.customfont(.medium, fontSize: 16))
                    .foregroundColor(.black)) {
                        ForEach($notifications) { $notification in
                            NotificationComponent(notificationType: 1, isClicked: $notification.isClicked)
                                .listRowSeparator(.hidden)
                        }
                    }

                Section(header: Text("Old")
                    .font(.customfont(.medium, fontSize: 16))
                    .foregroundColor(.black)) {
                        ForEach($notifications) { notification in
                            NotificationComponent(notificationType: 2, isClicked: .constant(true))
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
                                .font(.custom("HelveticaNeue-Semibold", size: 20))
                                .foregroundStyle(.black)
                            HStack {
                                Text("You have ")
                                Text("\(notifications.count) Notification")
                                    .foregroundStyle(.yellow)
                                Text(" Now")
                            }
                            .font(.custom("HelveticaNeue-Regular", size: 12))
                            .foregroundStyle(.black.opacity(0.6))
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Notification()
}

