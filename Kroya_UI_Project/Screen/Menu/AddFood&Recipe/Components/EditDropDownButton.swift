



import SwiftUI

struct EditDropDownButton: View {
    var onEdit: () -> Void
    var onDelete: () -> Void

    var body: some View {
        VStack {
            Menu {
                Button(action: onEdit) {
                    Label {
                        Text("Edit")
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } icon: {
                        Image(systemName: "pencil")
                            .foregroundColor(.green)
                    }
                }
                .frame(width: 200)

                Button(role: .destructive ,action: onDelete) {
                    Label {
                        Text("Delete")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } icon: {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.red)
                    }
                }
                .frame(width: 200)
            } label: {
                Image("ellipsis")
                    .padding(.trailing, 20)
            }
        }
    }
}

