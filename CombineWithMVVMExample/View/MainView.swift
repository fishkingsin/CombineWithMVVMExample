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
    @State var selectedRange: NSRange
    
    var outputs: MainViewModelOutputs { viewModel.outputs }
    var inputs: MainViewModelInputs { viewModel.inputs }
    
    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel())
        self.selectedRange = NSRange()
    }
    
    var body: some View {
        VStack {
            UIKitTextView("UIKitTextView", text: viewModel.outputs.textOnBinding, selectedRange: $selectedRange) {
                debugPrint("UIKitTextView: \(viewModel.outputs.textOnBinding.wrappedValue)")
            }
            CharacterLimitedTextField(text: viewModel.outputs.textOnBinding)
            
            CharacterLimitedTextFieldPublisherWrapper(inputs: viewModel.outputs.textPublisher, onValueChange: viewModel.inputs.setText)
                
            ToggleWrapper(
                title: "enable 1",
                valuePublisher: viewModel.outputs.switch1ValuePublisher,
                enabledPublisher: viewModel.outputs.switch1EnabledPublisher,
                onChanged: viewModel.inputs.enable1
            )
            // MARK: swiftui specific Binding
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

#Preview {
    MainView(viewModel: MainViewModel(textFieldWithDecimalLimitable: DefaultTextFieldWithDecimalLimitable(), cancellable: Set<AnyCancellable>()))
}
