//
//  MainViewModel.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 18/7/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import Combine
import CombineExt
import UIKit

func ignoreNil<T>(_ value: T?) -> AnyPublisher<T, Never> {
    value.map { Just($0).eraseToAnyPublisher()} ?? Empty().eraseToAnyPublisher()
}

public protocol MainViewModelInputs {
    func viewDidLoad()
    func viewDidAppear()
    func viewDidDisappear()
    func viewWillAppear()
    func viewWillDisappear()
    
    func setText(text: String)
    func setSelectedOption(option: String)
    func enable1(value: Bool)
    func enable2(value: Bool)
    func enable3(value: Bool)
    func getOptions2()
    func onButtonClick()
}

public protocol MainViewModelOutputs {
    var switch1EnabledPublisher: AnyPublisher<Bool, Never> { get }
    var switch2EnabledPublisher: AnyPublisher<Bool, Never> { get }
    var switch3EnabledPublisher: AnyPublisher<Bool, Never> { get }
    
    var switch1Enabled: Bool { get }
    var switch2Enabled: Bool { get }
    var switch3Enabled: Bool { get }
    
    var switch1ValuePublisher: AnyPublisher<Bool, Never> { get }
    var switch2ValuePublisher: AnyPublisher<Bool, Never> { get }
    var switch3ValuePublisher: AnyPublisher<Bool, Never> { get }
    var enableButton: AnyPublisher<Bool, Never> { get}
    var text: String { get set }
    var textPublisher: AnyPublisher<String, Never> { get}
    var options1: AnyPublisher<[String], Never> { get}
    var selectedOption: AnyPublisher<String, Never> { get}
    var options2: AnyPublisher<[UserGroupMemberPresentable], Never> { get}
    var didClickButton: AnyPublisher<Void, Never> { get}
    var progressBarVisibility: AnyPublisher<Int, Never> { get}
    var showBottomSheet: AnyPublisher<String, Never> { get}
    var enable1: AnyPublisher<Bool, Never> { get}
    var enable2: AnyPublisher<Bool, Never> { get}
    var enable3: AnyPublisher<Bool, Never> { get}
    var bottomsheetOptions: AnyPublisher<([String], String?), Never> { get}
}

public protocol MainViewModelType: ObservableObject {
    var inputs: MainViewModelInputs { get }
    var outputs: MainViewModelOutputs { get }
}

class MainViewModel<TextFieldLimitable>:
    MainViewModelType,
    MainViewModelInputs,
    MainViewModelOutputs where TextFieldLimitable: TextFieldWithDecimalLimitable {
    
    
    
    @Published var switch1Enabled: Bool = false
    
    @Published var switch2Enabled: Bool = false
    
    @Published var switch3Enabled: Bool = false
    
    @Published var switch1Value: Bool = false
    
    @Published var switch2Value: Bool = false
    
    @Published var switch3Value: Bool = false
    
    
    var textPublisher: AnyPublisher<String, Never> { $text.flatMap(ignoreNil).eraseToAnyPublisher() }
    @Published var text: String = ""
    
    var options1: AnyPublisher<[String], Never> { _options1.flatMap(ignoreNil).eraseToAnyPublisher() }
    private var _options1: CurrentValueRelay<[String]?> = CurrentValueRelay(nil)
    
    var selectedOption: AnyPublisher<String, Never> { _selectedOption.flatMap(ignoreNil).eraseToAnyPublisher() }
    private var _selectedOption: CurrentValueRelay<String?> = CurrentValueRelay(nil)
    
    var options2: AnyPublisher<[UserGroupMemberPresentable], Never> { _options2.flatMap(ignoreNil).eraseToAnyPublisher() }
    private var _options2: CurrentValueRelay<[UserGroupMemberPresentable]?> = CurrentValueRelay(nil)
    
    var didClickButton: AnyPublisher<Void, Never> { _didClickButton.flatMap(ignoreNil).eraseToAnyPublisher() }
    private var _didClickButton: PassthroughRelay<Void?> = PassthroughRelay()
    
    var progressBarVisibility: AnyPublisher<Int, Never> { _progressBarVisibility.flatMap(ignoreNil).eraseToAnyPublisher() }
    private var _progressBarVisibility: CurrentValueRelay<Int?> = CurrentValueRelay(nil)
    
    var showBottomSheet: AnyPublisher<String, Never> { _showBottomSheet.flatMap(ignoreNil).eraseToAnyPublisher() }
    private var _showBottomSheet: CurrentValueRelay<String?> = CurrentValueRelay(nil)
    
    var enable1: AnyPublisher<Bool, Never> { _enable1.flatMap(ignoreNil).eraseToAnyPublisher() }
    private var _enable1: CurrentValueRelay<Bool?> = CurrentValueRelay(nil)
    
    var enable2: AnyPublisher<Bool, Never> { _enable2.flatMap(ignoreNil).eraseToAnyPublisher() }
    private var _enable2: CurrentValueRelay<Bool?> = CurrentValueRelay(nil)
    
    var enable3: AnyPublisher<Bool, Never> { _enable3.flatMap(ignoreNil).eraseToAnyPublisher() }
    private var _enable3: CurrentValueRelay<Bool?> = CurrentValueRelay(nil)
    
    var bottomsheetOptions: AnyPublisher<([String], String?), Never> { _bottomsheetOptions.flatMap(ignoreNil).eraseToAnyPublisher() }
    private var _bottomsheetOptions: CurrentValueRelay<([String], String?)?> = CurrentValueRelay(nil)
    
    
    var inputs: MainViewModelInputs { self }
    var outputs: MainViewModelOutputs { self }
    
    
    var textFieldWithDecimalLimitable: TextFieldLimitable
    
    func setText(text: String) {
        if text.count > 10 {
            // constrain to 10
            self.text = String(text.prefix(10))
        }
    }
    
    func setSelectedOption(option: String) {
        _selectedOption.accept(option)
    }
    
    func enable1(value: Bool) {
        _enable1.accept(value)
    }
    
    func enable2(value: Bool) {
        _enable2.accept(value)
    }
    
    func enable3(value: Bool) {
        _enable3.accept(value)
    }
    
    func getOptions2() {
        _options2.accept([
            UserGroupMemberPresentable(name: "Naida Schill ✈️", role: "Staff Engineer - Mobile DevXP", avatarBackgroundColor: #colorLiteral(red: 0.7215686275, green: 0.9098039216, blue: 0.5607843137, alpha: 1)),
            UserGroupMemberPresentable(name: "Annalisa Doty", role: "iOS Engineer - NewXP", avatarBackgroundColor: #colorLiteral(red: 0.7176470588, green: 0.8784313725, blue: 0.9882352941, alpha: 1)),
            UserGroupMemberPresentable(name: "Petra Gazaway 🏡", role: "Senior iOS Product Engineer - Enterprise", avatarBackgroundColor: #colorLiteral(red: 0.9725490196, green: 0.937254902, blue: 0.4666666667, alpha: 1)),
            UserGroupMemberPresentable(name: "Jermaine Gill ⛷", role: "Staff Engineer - Mobile Infra", avatarBackgroundColor: #colorLiteral(red: 0.9490196078, green: 0.7568627451, blue: 0.9803921569, alpha: 1)),
            UserGroupMemberPresentable(name: "Juana Brooks 🚌", role: "Staff Software Engineer", avatarBackgroundColor: #colorLiteral(red: 0.9960784314, green: 0.8823529412, blue: 0.6980392157, alpha: 1)),
            UserGroupMemberPresentable(name: "Stacey Francis 🛳", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.8784313725, green: 0.8745098039, blue: 0.9921568627, alpha: 1)),
            UserGroupMemberPresentable(name: "Frederick Vargas", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.7215686275, green: 0.9098039216, blue: 0.5607843137, alpha: 1)),
            UserGroupMemberPresentable(name: "Michele Owens", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.7176470588, green: 0.8784313725, blue: 0.9882352941, alpha: 1)),
            UserGroupMemberPresentable(name: "Freda Ramsey", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.9725490196, green: 0.937254902, blue: 0.4666666667, alpha: 1)),
            UserGroupMemberPresentable(name: "Anita Thomas", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.9490196078, green: 0.7568627451, blue: 0.9803921569, alpha: 1)),
            UserGroupMemberPresentable(name: "Leona Lane", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.9960784314, green: 0.8823529412, blue: 0.6980392157, alpha: 1)),
            UserGroupMemberPresentable(name: "Chad Roy", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.8784313725, green: 0.8745098039, blue: 0.9921568627, alpha: 1)),
            UserGroupMemberPresentable(name: "Joan Guzman", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.7215686275, green: 0.9098039216, blue: 0.5607843137, alpha: 1)),
            UserGroupMemberPresentable(name: "Mike Yates", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.7176470588, green: 0.8784313725, blue: 0.9882352941, alpha: 1)),
            UserGroupMemberPresentable(name: "Elbert Wilson", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.9725490196, green: 0.937254902, blue: 0.4666666667, alpha: 1)),
            UserGroupMemberPresentable(name: "Anita Thomas", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.9490196078, green: 0.7568627451, blue: 0.9803921569, alpha: 1)),
            UserGroupMemberPresentable(name: "Leona Lane", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.9960784314, green: 0.8823529412, blue: 0.6980392157, alpha: 1)),
            UserGroupMemberPresentable(name: "Chad Roy", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.8784313725, green: 0.8745098039, blue: 0.9921568627, alpha: 1)),
            UserGroupMemberPresentable(name: "Naida Schill", role: "Staff Engineer - Mobile DevXP", avatarBackgroundColor: #colorLiteral(red: 0.7215686275, green: 0.9098039216, blue: 0.5607843137, alpha: 1))
        ]
        )
    }
    
    func onButtonClick() {
        _didClickButton.accept(())
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            self.getOptions2()
        }
        
    }
    
   
    
    var switch1EnabledPublisher: AnyPublisher<Bool, Never> {
        $text.map { $0 != "" }.eraseToAnyPublisher()
    }
    
    
    var switch2EnabledPublisher: AnyPublisher<Bool, Never> {
        $switch1Value.eraseToAnyPublisher()
    }
    
    var switch3EnabledPublisher: AnyPublisher<Bool, Never> {
        $switch2Value
            .map{ $0 == true }
            .eraseToAnyPublisher()
    }
    
    var switch1ValuePublisher: AnyPublisher<Bool, Never> {
        _enable1
            .combineLatest($text.compactMap{ $0 })
            .map {
                $0.0 == true && $0.1 != ""
            }
            .eraseToAnyPublisher()
    }
    
    var switch2ValuePublisher: AnyPublisher<Bool, Never> {
        _enable2
            .combineLatest($switch1Value)
            .map {
                $0.0 == true && $0.1 == true
            }
            .eraseToAnyPublisher()
    }
    
    var switch3ValuePublisher: AnyPublisher<Bool, Never> {
        _enable3
            .combineLatest($switch2Value)
            .map {
                $0.0 == true && $0.1 == true
            }
            .eraseToAnyPublisher()
    }
    
    var enableButton: AnyPublisher<Bool, Never> {
        $text
            .combineLatest(
                _enable1,
                _enable2,
                _enable3
            )
            .map {
                print("enable button \(String(describing: $0.0)) \($0.1) \($0.2) \($0.3)")
                return $0.0 != "" && $0.1 == true && $0.2 == true && $0.3 == true
            }
            .eraseToAnyPublisher()
    }

    /* initialize Some Usecase or AppState */
    
    init(textFieldWithDecimalLimitable: TextFieldLimitable) {
        self.textFieldWithDecimalLimitable = textFieldWithDecimalLimitable
    }
    
    func viewDidLoad() { }
    
    func viewDidAppear() { }
    
    func viewDidDisappear() { }
    
    func viewWillAppear() { }
    
    func viewWillDisappear() { }
    
    // extra Business logic
    var cursorPosition: Int? = 0
}



//extension MainViewModel: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        return textFieldWithDecimalLimitable.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
//    }
//    
//}
