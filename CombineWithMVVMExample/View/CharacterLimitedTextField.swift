//
//  CharacterLimitedTextField.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 16/12/2024.
//

import SwiftUI
import Combine

struct CharacterLimitedTextField: View {
    @Binding var text: String
    let characterLimit: Int
    
    init(text: Binding<String>, characterLimit: Int = 15) {
        self._text = text
        self.characterLimit = characterLimit
    }
    
    var body: some View {
        TextField("Placeholder", text: $text)
            .onChange(of: text) { newValue in
                if newValue.count > characterLimit {
                    text = String(newValue.prefix(characterLimit))
                }
            }
    }
}
