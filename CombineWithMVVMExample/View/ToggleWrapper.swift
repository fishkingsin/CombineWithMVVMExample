//
//  ToggleWrapper.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 18/12/2024.
//
import SwiftUI
import Combine

// MARK: if you bind published value to swiftui view directly
struct ToggleWrapper: View {
    let title: String
    @State var isOn: Bool = false
    @State var enabled: Bool = false
    let valuePublisher: AnyPublisher<Bool, Never>
    let enabledPublisher: AnyPublisher<Bool, Never>
    var onChanged: (Bool) -> Void
    
    init(title: String, valuePublisher: AnyPublisher<Bool, Never>, enabledPublisher: AnyPublisher<Bool, Never>, onChanged: @escaping (Bool) -> Void) {
        self.title = title
        self.valuePublisher = valuePublisher
        self.enabledPublisher = enabledPublisher
        self.onChanged = onChanged
    }
    
    
    var body: some View {
        Toggle(title, isOn: $isOn)
            .disabled(!enabled)
            .onReceive(valuePublisher) {
                isOn = $0
            }
            .onReceive(enabledPublisher) {
                enabled = $0
            }.onChange(of: isOn) {
                onChanged($0)
            }
    }
}
