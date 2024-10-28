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
                TextField("", text: $code[index])
                    .keyboardType(.numberPad)
                    .frame(width: 48, height: 48)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                    .focused($focusedField, equals: index)
                    .onChange(of: code[index]) { newValue in
                        handleTextChange(for: index, newValue: newValue)
                    }
                    .onReceive(code[index].publisher.collect()) {
                        // Ensure the user can only input one character at a time
                        let filtered = String($0.prefix(1))
                        if filtered != code[index] {
                            code[index] = filtered
                        }
                    }
            }
        }
        .onAppear {
            focusedField = 0 // Focus on the first field when the view appears
        }
    }
    
    // Handle text change logic
    private func handleTextChange(for index: Int, newValue: String) {
        // Ensure only 1 character is allowed per field
        if newValue.count > 1 {
            code[index] = String(newValue.prefix(1)) // Restrict to 1 character
        }
        
        // Auto-focus logic: Move to next field when input is entered
        if !newValue.isEmpty {
            if index < numberOfFields - 1 {
                focusedField = index + 1
            } else {
                focusedField = nil // Done entering OTP
            }
        } else {
            // Move to the previous field if input is deleted
            if index > 0 {
                focusedField = index - 1
            }
        }
    }
}

struct OTPTextField_Previews: PreviewProvider {
    static var previews: some View {
        OTPTextField(numberOfFields: 6, code: .constant(Array(repeating: "", count: 6)))
    }
}
