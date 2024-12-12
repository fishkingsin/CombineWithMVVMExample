//
//  MainView.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 12/12/2024.
//

import SwiftUI

struct MainView<ViewModel>: View where ViewModel: MainViewModel<DefaultTextFieldWithDecimalLimitable> {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack {
            TextField("Placeholder", text: $viewModel.text).onChange(of: viewModel.text) { newText in
                viewModel.inputs.setText(text: newText)
                
            }
            
        }.padding()
    }
}

#Preview {
    MainView(viewModel: MainViewModel(textFieldWithDecimalLimitable: DefaultTextFieldWithDecimalLimitable()))
}
