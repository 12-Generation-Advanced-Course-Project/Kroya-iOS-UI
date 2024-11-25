

import SwiftUI

struct NotificationView: View {
    
    @StateObject private var viewModel = NotificationViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    Text("New")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.leading, 15)
                    
                    ForEach(viewModel.notifications) { notification in
                        NotificationComponent(notification: notification)
                    }
                    
                    Text("Older")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.leading, 15)
                    ForEach(viewModel.notifications) { notification in
                        NotificationComponent(notification: notification)
                    }
                    
                }
                .padding(.top, 20)
               
               
            }
            .scrollIndicators(.hidden)
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                VStack(alignment: .leading, spacing: 10){
                    Text("Notifications")
                        .font(.system(size: 16, weight: .semibold))
                    HStack {
                        Text(LocalizedStringKey("You have"))
                        Text("\(viewModel.notifications.count) Notifications")
                            .foregroundStyle(.yellow)
                        Text(LocalizedStringKey("Today"))
                    }
                    .font(.custom("HelveticaNeue-Regular", size: 12))
                    .foregroundStyle(.black.opacity(0.6))
                }
                .padding(.top, 10)
                .padding(.leading, -20)
            }
        }
        .onAppear {
            viewModel.fetchNotifications()
        }
    }
}


