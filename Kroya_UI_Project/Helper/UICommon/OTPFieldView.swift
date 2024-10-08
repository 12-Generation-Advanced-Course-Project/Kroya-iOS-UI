//
//  OTPFieldView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 2/10/24.
//

import SwiftUI

struct OTPTextField: View {
    let numberOfFields: Int
    @State var enterValue: [String]
    @FocusState private var focusedField: Int?
    @State private var oldValue = ""
    
    init(numberOfFields: Int) {
        self.numberOfFields = numberOfFields
        self.enterValue = Array(repeating: "", count: numberOfFields)
    }
    
    var body: some View {
        HStack {
            ForEach(0..<numberOfFields, id: \.self) { index in
                TextField("", text: $enterValue[index], onEditingChanged: { editing in
                    if editing {
                        oldValue = enterValue[index]
                    }
                })
                .keyboardType(.numberPad)
                .frame(width: 48, height: 48)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: index)
                .tag(index)
                .onChange(of: enterValue[index]) { oldValue, newValue in
                    handleTextChange(for: index, oldValue: oldValue, newValue: newValue)
                }
            }
        }
    }
    
    // Handle text change logic
    private func handleTextChange(for index: Int, oldValue: String, newValue: String) {
        if enterValue[index].count > 1 {
            let currentValue = Array(enterValue[index])
            
            if currentValue[0] == Character(oldValue) {
                enterValue[index] = String(enterValue[index].suffix(1))
            } else {
                enterValue[index] = String(enterValue[index].prefix(1))
            }
        }
        
        // Auto-focus logic
        if !newValue.isEmpty {
            if index == numberOfFields - 1 {
                focusedField = nil
            } else {
                focusedField = (focusedField ?? 0) + 1
            }
        } else {
            focusedField = (focusedField ?? 0) - 1
        }
    }
}

struct OTPTextField_Previews: PreviewProvider {
    static var previews: some View {
        OTPTextField(numberOfFields: 4)
    }
}
