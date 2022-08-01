//
//  TextFieldWithDecimalLimitable.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 1/8/2022.
//

import UIKit

protocol TextFieldWithDecimalLimitable: AnyObject {
    var cursorPosition: Int? { get set }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func processTextInputChange(text replacedText: String, input inputString: String, cursorPosition: Int?) -> Bool
    func getCursorPosition(_ textField: UITextField, isAppend: Bool) -> Int?
    func validateString(string: String) -> Bool
    func setCursorPosition(_ textField: UITextField)
}
