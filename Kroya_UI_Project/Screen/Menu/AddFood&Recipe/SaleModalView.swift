import SwiftUI

struct Ingret: Identifiable, Codable {
    var id = UUID()
    var cookDate: String
    var amount: String
    var price: String
    var location: String
    var selectedCurrency: Int
}

struct CurrencyConverter {
    var totalRiel: String
    
    // Conversion rate from Riel to Dollar
    private let conversionRate: Double = 4100.0
    
    var totalDollar: String {
        if let rielAmount = Double(totalRiel) {
            let dollarAmount = rielAmount / conversionRate
            return String(format: "%.2f", dollarAmount)
        } else {
            return "Invalid amount"
        }
    }
}

struct SaleModalView: View {
//    @Binding var shouldPopToRootView : Bool
    @Environment(\.dismiss) var dismiss
    @Binding var ingret: Ingret
    @State private var isAvailableForSale: Bool? = nil
    @State private var seletedDate = Date()
    @State private var isDatePickerVisible: Bool = false
    @State var selectedDate  = Date()
    @State var amount: String = ""
    @State var price: String = ""
    @State var location: String = ""

    var totalRiel: String = "12000"
    let currencies = ["៛", "$"]
    let dismissToRoot : DismissAction

    var body: some View {
        
        let converter = CurrencyConverter(totalRiel: totalRiel)
        
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .trailing, spacing: 15) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Is this food available for sale?")
                            .font(.customfont(.bold, fontSize: 16))
                        VStack(spacing: 25) {
                            Button(action: {
                                isAvailableForSale = true
                            }) {
                                Text("Yes")
                                    .font(.customfont(.semibold, fontSize: 16))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(isAvailableForSale == true ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
                                    .foregroundColor(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isAvailableForSale == true ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 4)
                                    )
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            
                            Button(action: {
                                isAvailableForSale = false
                            }) {
                                Text("No")
                                    .font(.customfont(.semibold, fontSize: 16))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(isAvailableForSale == false ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
                                    .foregroundColor(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isAvailableForSale == false ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 4)
                                    )
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 20)
                    }
                    
                    // Show details only if available for sale is Yes
                    if isAvailableForSale == true {
                        VStack(alignment: .leading){
                            Text("Details")
                                .font(.customfont(.bold, fontSize: 16))
                                .padding(.vertical, 20)
                            
                            VStack(spacing: 20) {
                                HStack(spacing: 10) {
                                    Text("Cook date")
                                        .font(.customfont(.regular, fontSize: 15))
                                        .foregroundStyle(.black.opacity(0.6))
                                        .frame(minWidth: 100, alignment: .leading)
                                    Spacer()
                                    TextField(selectedDate.formatted(.dateTime.day().month().year()), text: $ingret.cookDate)
                                        .multilineTextAlignment(.leading)
                                        .font(.customfont(.medium, fontSize: 15))
                                        Button {
                                        isDatePickerVisible = true
                                    } label: {
                                        Image(systemName: "calendar")
                                            .font(.customfont(.light, fontSize: 25))
                                            .foregroundColor(.gray)
                                        
                                    }
                                    .overlay(
                                        DatePicker(selection: $selectedDate, in: Date()..., displayedComponents: .date) {
                                        }
                                            .labelsHidden()
                                            .colorMultiply(.clear))
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                                Divider()
                                
                                HStack {
                                    Text("Amount")
                                        .font(.customfont(.regular, fontSize: 15))
                                        .foregroundStyle(.black.opacity(0.6))
                                        .frame(maxWidth: 120, alignment: .leading)
                                    TextField("00", text: $amount)
                                        .multilineTextAlignment(.leading)
                                        .font(.customfont(.medium, fontSize: 15))
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                }
                                .padding(.horizontal)
                                Divider()
                                
                                HStack{
                                    Text("Price")
                                        .font(.customfont(.regular, fontSize: 15))
                                        .foregroundStyle(.black.opacity(0.6))
                                        .frame(maxWidth: 120, alignment: .leading)
                                    HStack {
                                        TextField("0.0", text: $price)
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
                                }
                                .padding(.horizontal)
                                Divider()
                                
                                HStack {
                                    Text("Location")
                                        .font(.customfont(.regular, fontSize: 15))
                                        .foregroundStyle(.black.opacity(0.6))
                                        .frame(maxWidth: 120, alignment: .leading)
                                    TextField("St323", text: $location)
                                        .multilineTextAlignment(.leading)
                                        .font(.customfont(.medium, fontSize: 15))
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
                            )
                            // Error message if any required fields are empty
                            if amount.isEmpty || price.isEmpty || location.isEmpty {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                    Text(LocalizedStringKey("Detail information cannot be empty"))
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }
                        }
                        
                        
                        VStack {
                            Text("Ingredient ")
                                .font(.customfont(.medium, fontSize: 13))
                                .foregroundColor(.black.opacity(0.4)) +
                            Text("\(totalRiel)Riel ")
                                .foregroundStyle(.yellow)
                                .font(.customfont(.medium, fontSize: 13)) +
                            Text("( \(converter.totalDollar)$ )")
                                .font(.customfont(.medium, fontSize: 13))
                                .foregroundColor(.black.opacity(0.4))
                        }
                    }
                    
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
            
            Button(action: {
                
            }) {
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
               
                NavigationLink(destination: RecipeModalView(dismissToRoot: dismiss)) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
            }
            
        }
    }
}


//#Preview {
//    let sampleIngret = Ingret(cookDate: "", amount: "", price: "", location: "", selectedCurrency: 0)
//    SaleModalView(ingret: .constant(sampleIngret))
//}






