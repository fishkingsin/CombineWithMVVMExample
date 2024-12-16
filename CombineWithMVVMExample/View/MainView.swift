//
//  MainView.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 12/12/2024.
//

import SwiftUI
import Combine

struct MainView<ViewModel>: View where ViewModel: MainViewModelType {
    
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        VStack {
            CharacterLimitedTextField(text: viewModel.outputs.textOnBinding)
            
            CharacterLimitedTextFieldPublisherWrapper(inputs: viewModel.outputs.textPublisher, onValueChange: viewModel.inputs.setText)
                
            
            Toggle("enable 1", isOn: viewModel.outputs.switch1ValueOnBinding).disabled(!viewModel.outputs.switch1Enabled)
            Toggle("enable 1", isOn: viewModel.outputs.switch2ValueOnBinding).disabled(!viewModel.outputs.switch2Enabled)
            Toggle("enable 1", isOn: viewModel.outputs.switch3ValueOnBinding).disabled(!viewModel.outputs.switch3Enabled)
            Button("Show Sheet", action: viewModel.inputs.onButtonClick)
                .disabled(!viewModel.outputs.enableButton)
                .sheet(isPresented: viewModel.outputs.showBottomSheetOnBinding) {
                    BottomSheetView(
                        selectedIds: viewModel.outputs.selectedIdsOnBinding,
                        options: viewModel.outputs.options2,
                        onDismissClick: viewModel.inputs.onDismissClick) }
            
        }
        
        .padding()
    }
}

struct CharacterLimitedTextFieldPublisherWrapper: View {
    @State var text: String = ""
    var inputs: AnyPublisher<String, Never>
    var onValueChange: (String) -> Void
    
    var body: some View {
        CharacterLimitedTextField(text: .init(get: {
            text
        }, set: { newValue in
            text = newValue
        }))
        .onChange(of: text) {
            onValueChange($0)
        }.onReceive(inputs) {
            text = $0
        }
    }
}


struct CharacterLimitedTextField: View {
    @Binding var text: String
    let characterLimit: Int = 5
    var body: some View {
        TextField("Placeholder", text: $text)
            .onChange(of: text) { newValue in
                if newValue.count > characterLimit {
                    text = String(newValue.prefix(characterLimit))
                }
            }
    }
}

#Preview {
    MainView(viewModel: MainViewModel(textFieldWithDecimalLimitable: DefaultTextFieldWithDecimalLimitable(), cancellable: Set<AnyCancellable>()))
}
