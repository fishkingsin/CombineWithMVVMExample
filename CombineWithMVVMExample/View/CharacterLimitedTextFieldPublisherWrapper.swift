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
    var inputs: AnyPublisher<String, Never>
    var onValueChange: (String) -> Void
    
    var body: some View {
        CharacterLimitedTextField(text: $text)
        .onChange(of: text) {
            onValueChange($0)
        }.onReceive(inputs) {
            text = $0
        }
    }
}
