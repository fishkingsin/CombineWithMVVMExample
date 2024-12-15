//
//  View+binding.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 15/12/2024.
//

import Foundation
import Combine
import SwiftUI

extension View {

    func binding(@CancellableBuilder bindings: @escaping () -> AnyCancellable) -> some View {
        return BindingView(content: AnyView(self), bindings: bindings)
    }

}

@resultBuilder
enum CancellableBuilder {

    static func buildBlock(_ cancellable: Cancellable) -> AnyCancellable {
        return cancellable.eraseType()
    }

    static func buildBlock(_ cancellables: Cancellable...) -> AnyCancellable {
        return cancellables.map { $0.eraseType() }.eraseType()
    }

}

extension Array: @retroactive Cancellable where Element: Cancellable {

    public func cancel() {
        for element in self {
            element.cancel()
        }
    }

}

extension Cancellable {

    fileprivate func eraseType() -> AnyCancellable {
        return AnyCancellable(self)
    }

}

private struct BindingView: View {
    let content: AnyView
    let bindings: () -> AnyCancellable

    @State
    private var cancellableSet: Set<AnyCancellable> = []

    var body: some View {
        content
            .onAppear {
                guard self.cancellableSet.isEmpty else { return }
                self.bindings().store(in: &self.cancellableSet)
            }
            .onDisappear {
                self.cancellableSet = []
            }
    }
}
