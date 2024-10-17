import SwiftUI

struct Ingret: Identifiable, Codable {
    var id = UUID()
    var cookDate: String
    var amount: String
    var price: String
    var location: String
    var selectedCurrency: Int
}

struct SaleModalView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var ingret: Ingret
    
    let currencies = ["៛", "$"]
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .trailing, spacing: 15) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Is this food available for sell?")
                                .font(.customfont(.bold, fontSize: 16))
                            VStack(spacing: 25) {
                                Button(action: {}) {
                                    Text("Yes")
                                        .font(.customfont(.semibold, fontSize: 16))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(.yellow.opacity(0.3))
                                        )
                                        .foregroundColor(.black)
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.yellow.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal)
                                
                                Button(action: {}) {
                                    Text("No")
                                        .font(.customfont(.semibold, fontSize: 16))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color(red: 0.956, green: 0.959, blue: 0.97))
                                        )
                                        .foregroundColor(.black)
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.gray.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal)
                            }
                            Text("Details")
                                .padding(.vertical, 20)
                                .font(.customfont(.bold, fontSize: 16))
                        }
                        
                        VStack (spacing: 20){
                            HStack(spacing: 10){
                                Text("Cook date")
                                    .font(.customfont(.regular, fontSize: 15))
                                    .foregroundStyle(.black.opacity(0.6))
                                    .frame(minWidth: 100, alignment: .leading)
                                Spacer()
                                HStack{
                                    TextField("dd/mm/yyyy", text: $ingret.cookDate)
                                        .multilineTextAlignment(.leading)
                                        .font(.customfont(.medium, fontSize: 15))
                                    Image(systemName: "calendar")
                                        .font(.customfont(.light, fontSize: 25))
                                        .foregroundColor(.gray)
                                    Spacer()
                                    
                                }
                                .frame(maxWidth: .infinity,alignment: .leading)
                            }
                            .padding(.horizontal)
                            Divider()
                            
                            HStack(spacing:10){
                                Text("Amount")
                                    .font(.customfont(.regular, fontSize: 15))
                                    .foregroundStyle(.black.opacity(0.6))
                                    .frame(minWidth: 100, alignment: .leading)
                                Spacer()
                                HStack{
                                    TextField("00", text: $ingret.amount)
                                        .multilineTextAlignment(.leading)
                                        .font(.customfont(.medium, fontSize: 15))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            .padding(.horizontal)
                            Divider()
                            
                            HStack(spacing: 10){
                                Text("Price")
                                    .font(.customfont(.regular, fontSize: 15))
                                    .foregroundStyle(.black.opacity(0.6))
                                    .frame(minWidth: 100, alignment: .leading)
                                Spacer()
                                
                                HStack{
                                    TextField("0.0", text: $ingret.price)
                                        .multilineTextAlignment(.leading)
                                        .font(.customfont(.medium, fontSize: 15))
                                    Picker("", selection: $ingret.selectedCurrency) {
                                        ForEach(0..<currencies.count) { index in
                                            Text(currencies[index])
                                                .tag(index)
                                                .font(.customfont(.medium, fontSize: 20))
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .frame(width: 60)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal)
                            Divider()
                            
                            HStack(spacing:10){
                                Text("Location")
                                    .font(.customfont(.regular, fontSize: 15))
                                    .foregroundStyle(.black.opacity(0.6))
                                    .frame(minWidth: 100, alignment: .leading)
                                Spacer()
                                HStack{
                                    TextField("St323", text: $ingret.location)
                                        .multilineTextAlignment(.leading)
                                        .font(.customfont(.medium, fontSize: 15))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 12)
                        .frame(width: .screenWidth * 0.95)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
                        )
                        
                        VStack {
                            Text("Ingredient ")
                                .font(.customfont(.medium, fontSize: 13))
                                .foregroundColor(.black.opacity(0.4)) +
                            Text("12000Riel ")
                                .foregroundStyle(.yellow)
                                .font(.customfont(.medium, fontSize: 13)) +
                            Text("( 3$ )")
                                .font(.customfont(.medium, fontSize: 13))
                                .foregroundColor(.black.opacity(0.4))
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                HStack(spacing: 10) {
                    Button(action: {}) {
                        Text("Back")
                            .font(.customfont(.semibold, fontSize: 16))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.956, green: 0.959, blue: 0.97))
                            )
                            .foregroundColor(.black)
                    }
                    
                    Button(action: {}) {
                        Text("Post")
                            .font(.customfont(.semibold, fontSize: 16))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.yellow)
                            )
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .navigationBarBackButtonHidden(true)
                .navigationTitle("Sale")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    @Previewable @State var ingretBinding = sampleIngret
//    let sampleIngret = Ingret(cookDate: "", amount: "", price: "", location: "", selectedCurrency: 0)
//    
//    SaleModalView(ingret: $ingretBinding)
//}
