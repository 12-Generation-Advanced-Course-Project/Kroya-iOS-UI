
import SwiftUI

struct Notification: View {
    
    let notification = [1,2,3,4]
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading,spacing: 10){
                List {
                    Section(header: Text("Today")
                        .font(.customfont(.semibold, fontSize: 16))) {
                            ForEach(notification, id: \.self) { notification in
                                NotificationComponent(notificationType: 1)
                                    .padding(.vertical, 5)
                            }
                        }
                    Section(header: Text("This Week")
                        .font(.customfont(.semibold, fontSize: 16))) {
                            ForEach(notification, id: \.self) { notification in
                                NotificationComponent(notificationType: 3)
                                    .padding(.vertical, 5)
                            }
                        }
                }
                .listStyle(PlainListStyle())
             
            }
            .navigationTitle("Notification")
        }
    }
}
#Preview {
    Notification()
}
