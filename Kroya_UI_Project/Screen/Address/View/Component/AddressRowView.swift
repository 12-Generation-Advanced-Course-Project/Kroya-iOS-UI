import SwiftUI

struct AddressRowView: View {
    
    var address: Address
    var onUpdate: () -> Void = {}
    var onDelete: () -> Void = {}
    var isDefault: Bool = false
    @State var isShowPopup : Bool = false
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack{
                        Text(address.addressDetail)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.black)
                            .opacity(0.6)
                            .lineLimit(2)
                    }
                    Text(address.specificLocation)
                        .font(.customfont(.regular, fontSize: 12))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .opacity(0.4)
                        .lineLimit(1)
                }
                Spacer()
                Text(address.tag)
                    .foregroundColor(PrimaryColor.normal)
                    .font(.system(size: 15, weight: .semibold))
                Button(action: {
                    isShowPopup.toggle()
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 19, weight: .medium))
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(90))
                }
                .popover(isPresented: $isShowPopup, attachmentAnchor: .point(.topTrailing), arrowEdge: .top) {
                    CustomMenuView(showPopup: $isShowPopup, onUpdate: onUpdate, onDelete: onDelete)
                        .presentationCompactAdaptation(.none)
                }
            }
            .padding(.vertical, 5)
            .padding(.leading,5)
            Divider()
        }
   
//        .onTapGesture {
//           
//        }
    }
}
