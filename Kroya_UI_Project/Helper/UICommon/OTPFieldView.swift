//
//  OTPFieldView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 2/10/24.
//

import SwiftUI

struct OTPTextField: View {
    let numberOfFields: Int
    @Binding var code: [String]
    @FocusState private var focusedField: Int?
    
    var body: some View {
        HStack {
            ForEach(0..<numberOfFields, id: \.self) { index in
                TextField("", text: $code[index], onEditingChanged: { editing in })
                    .keyboardType(.numberPad)
                    .frame(width: 48, height: 48)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                    .focused($focusedField, equals: index)
                    .tag(index)
                    .onChange(of: code[index]) { oldValue, newValue in
                        handleTextChange(for: index, oldValue: oldValue, newValue: newValue)
                    }
            }
        }
    }
    
    // Handle text change logic
    private func handleTextChange(for index: Int, oldValue: String, newValue: String) {
        if code[index].count > 1 {
            let currentValue = Array(code[index])
            
            
            if !oldValue.isEmpty, let firstOldChar = oldValue.first {
                if currentValue[0] == firstOldChar {
                    code[index] = String(code[index].suffix(1))
                } else {
                    code[index] = String(code[index].prefix(1))
                }
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
        OTPTextField(numberOfFields: 6, code: .constant(Array(repeating: "", count: 6)))
    }
}
