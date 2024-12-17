//
//  CharacterLimitedTextFieldPublisherWrapper.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 16/12/2024.
//

import SwiftUI
import Combine

struct CharacterLimitedTextFieldPublisherWrapper: View {
    @State var text: String = ""
    let characterLimit: Int
    var inputs: AnyPublisher<String, Never>
    var onValueChange: (String) -> Void
    
    init(characterLimit: Int = 15, inputs: AnyPublisher<String, Never>, onValueChange: @escaping (String) -> Void) {
        self.characterLimit = characterLimit
        self.inputs = inputs
        self.onValueChange = onValueChange
    }
    
    var body: some View {
        CharacterLimitedTextField(text: $text, characterLimit: characterLimit)
        .onChange(of: text) {
            onValueChange($0)
        }.onReceive(inputs) {
            text = $0
        }
    }
}
