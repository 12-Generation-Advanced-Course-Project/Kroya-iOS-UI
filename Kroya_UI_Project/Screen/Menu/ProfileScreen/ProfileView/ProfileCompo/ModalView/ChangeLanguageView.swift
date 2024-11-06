//
//  ChangeLanguageView.swift
//  Kroya_UI_Project
//
//  Created by PVH_003 on 15/10/24.
//

import SwiftUI

struct ChangeLanguageView: View {
    @State private var showingCredits = false
//    @State private var selectedLanguage: String? = "English"
    @State private var selectedLanguage: String? = UserDefaults.standard.string(forKey: "AppLanguage") ?? "English"
    @Binding var lang: String
    
    let languages = [
        ("English", "English", "en"),
        ("Khmer", "ភាសាខ្មែរ","km-KH"),
        ("Korean", "한국", "ko")
    ]
    
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                Text(LocalizedStringKey("Change Language"))
                    .font(.customfont(.bold, fontSize: 16))
                Text(LocalizedStringKey("Which language do you prefer?"))
                    .font(.customfont(.medium, fontSize: 13))
                    .foregroundColor(.black.opacity(0.5))
            }
            .padding()
            
            ForEach(languages, id: \.0) { language in
                Button(action: {
                    lang = language.2 // Set the selected language
                    selectedLanguage = language.2
                    UserDefaults.standard.set(language.2, forKey: "AppLanguage") // Save language code
                }) {
                    HStack {
                        Image(language.0)
                        Text(language.1)
                            .foregroundColor(.black.opacity(0.5))
                        Spacer()
                        if selectedLanguage == language.2 {
                            Image(systemName: "checkmark")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(selectedLanguage == language.2 ? Color.yellow.opacity(0.5) : Color.clear)
                    .cornerRadius(8)
                }
            }
            
            Spacer()
        }
        .padding()
        .presentationDetents([.height(300)])
        .presentationDragIndicator(.hidden)
        .environment(\.locale, .init(identifier: lang))
    }
    
}

//#Preview {
//    ChangeLanguageView()
//}
