//
//  TextFieldWithDecimalLimitable.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 1/8/2022.
//

import UIKit

final class TextFieldWithDecimalLimitable: TextFieldLimitable {
    func getCursorPosition(_ textField: UITextField, isAppend: Bool) -> Int? {
        cursorPosition = textField.text?.count
        return cursorPosition
    }
    
    func setCursorPosition(_ textField: UITextField) {
        cursorPosition = textField.text?.count
    }
    
    var cursorPosition: Int? = 0
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

protocol TextFieldLimitable: AnyObject {
    var cursorPosition: Int? { get set }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func processTextInputChange(text replacedText: String, input inputString: String, cursorPosition: Int?) -> Bool
    func getCursorPosition(_ textField: UITextField, isAppend: Bool) -> Int?
    func validateString(string: String) -> Bool
    func setCursorPosition(_ textField: UITextField)
}

extension TextFieldLimitable {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard validateString(string: string) else { return false }
        return true
    }
    
    func processTextInputChange(text replacedText: String, input inputString: String, cursorPosition: Int?) -> Bool {
        guard validateString(string: inputString) else { return false }
        return true
    }
    
    func validateString(string: String) -> Bool {
        // MARK: default behaviour
        return true
    }
    
}
