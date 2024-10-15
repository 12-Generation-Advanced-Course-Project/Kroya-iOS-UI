//
//  ChangeLanguageView.swift
//  Kroya_UI_Project
//
//  Created by PVH_003 on 15/10/24.
//

import SwiftUI

struct ChangeLanguageView: View {
    @State private var showingCredits = false
    @State private var selectedLanguage: String? = nil
    
    let languages = [
        ("English", "English"),
        ("Khmer", "ភាសាខ្មែរ"),
        ("Korean", "한국")
    ]
    
    var body: some View {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Change Language")
                        .font(.customfont(.bold, fontSize: 16))
                    Text("Which language do you prefer?")
                        .font(.customfont(.medium, fontSize: 13))
                        .foregroundColor(.black.opacity(0.5))
                }
                .padding()
                
                ForEach(languages, id: \.0) { language in
                    HStack {
                        Image(language.0)
                        HStack {
                            Text(language.1)
                                .foregroundColor(.black.opacity(0.5))
                            Spacer()
                            if selectedLanguage == language.0 {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(selectedLanguage == language.0 ? Color.yellow.opacity(0.5) : Color.clear)
                    .cornerRadius(8)
                    .onTapGesture {
                        selectedLanguage = language.0
                    }
                }
                
                Spacer()
            }
            .padding()
            .presentationDetents([.height(300)])
            .presentationDragIndicator(.hidden)
        }
    
}

#Preview {
    ChangeLanguageView()
}
