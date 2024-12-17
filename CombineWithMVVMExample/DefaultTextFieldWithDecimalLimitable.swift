//
//  DefaultTextFieldWithDecimalLimitable.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 1/8/2022.
//

import Foundation
import UIKit

// default behaviour
class DefaultTextFieldWithDecimalLimitable: TextFieldLimitable {
    var cursorPosition: Int? = 0
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            
            cursorPosition = getCursorPosition(textField, isAppend: string.count > 0)
            return processTextInputChange(text: text, input: string, cursorPosition: cursorPosition)
        }
        return false
    }
    
    func processTextInputChange(text replacedText: String, input inputString: String, cursorPosition: Int?) -> Bool {
        // decimalPad will display "," instead of "." in France region , so we need convert logic. defect STMA-7405
        let text = replacedText.replacingOccurrences(of: ",", with: ".")
        var input = inputString
        if inputString == "," {
            input = "."
        }
        
        switch input {
        case ".":
            if text.count == 1 /* start from . */ || text.filter({ char -> Bool in
                char.description.contains(".")
            }).count > 1 {
                return false
            } else if cursorPosition == text.count { // append "." at tail.
                return true
            } else {
                return validateString(string: text)
            }
        case "0":
            let decimalPlaces: Int = 2 /// temp fix for SG
            if text.count == 1 /* start from 0 */ {
                return validateString(string: text)
            } else if !text.contains(".") {
                return validateString(string: text)
            } else if text.contains("."), let range = text.range(of: "."), text[range.upperBound...].count <= decimalPlaces {
                return true
            } else {
                return false
            }
        case "": // delete case
            if let lastCharacter = text.last, [".", "0"].contains(lastCharacter), NSDecimalNumber(string: text).decimalValue == 0.0 {
                return true
            } else {
                return validateString(string: text)
            }
        default:
            return validateString(string: text)
        }
        
    }
    
    func validateString(string: String) -> Bool {
        let notAllowedCharSet = NSCharacterSet(charactersIn: "0123456789.").inverted
        if let range = string.rangeOfCharacter(from: notAllowedCharSet), !range.isEmpty {
            return false
        } else {
            let components = string.components(separatedBy: ".")
            if components.count > 2 {
                return false
            } else {
                if components.count == 1 {
                    if components[0].count > 9 {
                        return false
                    }
                    return true
                } else {
                    // if txt is 987654321.123, then insert 1 digital after 987654321, then block
                    if components[0].count > 9 {
                        return false
                    }
                    // MARK: - default 2 decimal places
                    return components[1].count <= 2 ? true : false
                }
            }
        }
    }
    
    func getCursorPosition(_ textField: UITextField, isAppend: Bool = true) -> Int? {
        if let selectedRange = textField.selectedTextRange {
            let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
            return cursorPosition + (isAppend ? 1 : -1)
        }
        return nil
    }
    
    func setCursorPosition(_ textField: UITextField) {
        if let currentValue: Int = cursorPosition {
            if let previousPosition = textField.position(from: textField.beginningOfDocument, offset: currentValue) {
                textField.selectedTextRange = textField.textRange(from: previousPosition, to: previousPosition)
            }
        }
    }
}
