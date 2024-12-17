//
//  UITextFieldWrapper.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 17/12/2024.
//

import UIKit
import SwiftUI

fileprivate struct UITextFieldWrapper<Limitable>: UIViewRepresentable where Limitable: TextFieldLimitable {
    typealias UIViewType = UITextField

    @Binding var text: String
    @Binding var selectedRange: NSRange
    @Binding var calculatedHeight: CGFloat
    var onDone: (() -> Void)?
    var textFieldLimitable: Limitable?
    
    init(text: Binding<String>, selectedRange: Binding<NSRange>, calculatedHeight: Binding<CGFloat>, textFieldLimitable: Limitable? = DefaultTextFieldWithDecimalLimitable(), onDone: (() -> Void)? = nil) {
        self._text = text
        self._selectedRange = selectedRange
        self._calculatedHeight = calculatedHeight
        self.textFieldLimitable = textFieldLimitable
        self.onDone = onDone
    }

    func makeUIView(context: UIViewRepresentableContext<UITextFieldWrapper>) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator

//        textField.isEditable = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
//        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
//        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        if nil != onDone {
            textField.returnKeyType = .done
        }

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ textField: UITextField, context: UIViewRepresentableContext<UITextFieldWrapper>) {
        if textField.text != self.text {
            textField.text = self.text
        }
        if textField.selectedRange != selectedRange {
            textField.setSelectedRange(selectedRange)
        }
//        if textField.window != nil, !textField.isFirstResponder {
//            textField.becomeFirstResponder()
//        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, selection: $selectedRange, height: $calculatedHeight, textFieldLimitable: textFieldLimitable, onDone: onDone)
    }

    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // !! must be called asynchronously
            }
        }
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var selection: Binding<NSRange>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?
        var textFieldLimitable: Limitable?
        
        init(text: Binding<String>,selection: Binding<NSRange>, height: Binding<CGFloat>, textFieldLimitable: Limitable?, onDone: (() -> Void)? = nil) {
            self.text = text
            self.selection = selection
            self.calculatedHeight = height
            self.textFieldLimitable = textFieldLimitable
            self.onDone = onDone
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            guard let string = textField.text else { return true }
            text.wrappedValue = string
            return true
        }
//        func textViewDidChange(_ textField: UITextField) {
//            guard let string = textField.text else { return }
//            text.wrappedValue = string
//            UITextFieldWrapper.recalculateHeight(view: textField, result: calculatedHeight)
//        }
        
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            guard let onDone = self.onDone else { return }
            textField.resignFirstResponder()
            onDone()
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let textFieldLimitable = textFieldLimitable else {
                if let onDone = self.onDone, string == "\n" {
                    textField.resignFirstResponder()
                    onDone()
                    return false
                }
                return true
            }
            return textFieldLimitable.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
            
        }

        
    }
    
}

extension UITextInput {
    var selectedRange: NSRange? {
        guard let range = selectedTextRange else { return nil }
        let location = offset(from: beginningOfDocument, to: range.start)
        let length = offset(from: range.start, to: range.end)
        return NSRange(location: location, length: length)
    }
    
    func setSelectedRange(_ range: NSRange?) {
        guard let range else { return }
        let length = range.upperBound-range.lowerBound
        guard let start = position(from: beginningOfDocument, offset: range.lowerBound),
              let end = position(from: start, offset: length) else { return }
        selectedTextRange = textRange(from: start, to: end)
                
    }
}

struct UIKitTextView: View {

    private var placeholder: String
    private var onCommit: (() -> Void)?

    @Binding private var text: String
    @Binding private var selectedRange: NSRange

    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.showingPlaceholder = $0.isEmpty
        }
    }

    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = false

    init (_ placeholder: String = "", text: Binding<String>, selectedRange: Binding<NSRange>, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self._text = text
        self._selectedRange = selectedRange
        self.onCommit = onCommit
        self._showingPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

    var body: some View {
        UITextFieldWrapper(text: self.internalText, selectedRange: $selectedRange, calculatedHeight: $dynamicHeight)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
            .background(placeholderView, alignment: .topLeading)
    }

    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
}
