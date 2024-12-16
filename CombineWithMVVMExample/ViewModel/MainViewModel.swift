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
import SwiftUI


extension MainViewModel {
    var textOnBinding: Binding<String> {
        .init(
            get: {
                self.text
            },
            set: {
                self.inputs.setText(text: $0)
            }
        )
    }
    
    var switch1ValueOnBinding: Binding<Bool> {
        .init(
            get: {
                self.switch1Value
            },
            set: {
                self.switch1Value = $0
                self.inputs.enable1(value: $0)
            }
        )
    }
    var switch2ValueOnBinding: Binding<Bool> {
        .init(
            get: {
                self.switch2Value
            },
            set: {
                self.switch2Value = $0
                self.inputs.enable2(value: $0)
            }
        )
    }
    var switch3ValueOnBinding: Binding<Bool> {
        .init(
            get: {
                self.switch3Value
            },
            set: {
                self.switch3Value = $0
                self.inputs.enable3(value: $0)
            }
        )
    }
    
    var showBottomSheetOnBinding: Binding<Bool> {
        .init(
            get: {
                self.showBottomSheet
            },
            set: {
                self.showBottomSheet = $0
            }
        )
    }
    
    var selectedIdsOnBinding: Binding<[UUID]> {
        .init(
            get: {
                self.selectedIds
            },
            set: {
                self.selectedIds = $0
            }
        )
    }
}


public protocol MainViewModelType: ObservableObject {
    var inputs: MainViewModelInputs { get }
    var outputs: MainViewModelOutputs { get }
}


class MainViewModel<TextFieldLimitable>:
    MainViewModelType,
    MainViewModelInputs,
    MainViewModelOutputs where TextFieldLimitable: TextFieldWithDecimalLimitable {
    
    
    
    @Published internal var switch1Enabled: Bool = false
    
    @Published internal var switch2Enabled: Bool = false
    
    @Published internal var switch3Enabled: Bool = false
    
    @Published internal var switch1Value: Bool = false
    
    @Published internal var switch2Value: Bool = false
    
    @Published internal var switch3Value: Bool = false
    
    @Published internal var selectedIds: [UUID] = []
    
    var textPublisher: AnyPublisher<String, Never> { $text.flatMap(ignoreNil).eraseToAnyPublisher() }
    
    @Published internal var text: String = ""
    
    var options1: AnyPublisher<[String], Never> { _options1.flatMap(ignoreNil).eraseToAnyPublisher() }
    private var _options1: CurrentValueRelay<[String]?> = CurrentValueRelay(nil)
    
    var selectedOption: AnyPublisher<String, Never> { _selectedOption.flatMap(ignoreNil).eraseToAnyPublisher() }
    private var _selectedOption: CurrentValueRelay<String?> = CurrentValueRelay(nil)
    
    var options2Publisher: AnyPublisher<[UserGroupMemberPresentable], Never> { $options2.flatMap(ignoreNil).eraseToAnyPublisher() }
    @Published private(set) var options2: [UserGroupMemberPresentable] = []
    
    var didClickButton: AnyPublisher<Void, Never> { _didClickButton.flatMap(ignoreNil).eraseToAnyPublisher() }
    private var _didClickButton: PassthroughRelay<Void?> = PassthroughRelay()
    
    var progressBarVisibility: AnyPublisher<Int, Never> { _progressBarVisibility.flatMap(ignoreNil).eraseToAnyPublisher() }
    private var _progressBarVisibility: CurrentValueRelay<Int?> = CurrentValueRelay(nil)
    
    
    var showBottomSheetPublisher: AnyPublisher<Bool, Never> { $showBottomSheet.flatMap(ignoreNil).eraseToAnyPublisher() }
    @Published internal var showBottomSheet: Bool = false
    
    
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
        self.text = String(text.prefix(10))
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
        guard options2.isEmpty else { return }
        options2 = [
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
        
    }
    
    func onButtonClick() {
        showBottomSheet = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
//            guard let self = self else { return }
            self.getOptions2()
//        }
        
    }
    
    func onDismissClick() {
        showBottomSheet = false
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
    @Published internal var enableButton = false
    var enableButtonPublisher: AnyPublisher<Bool, Never> {
        $text
            .combineLatest(
                _enable1,
                _enable2,
                _enable3
            ).map {
                print("enable button \(String(describing: $0.0)) \(String(describing: $0.1)) \(String(describing: $0.2)) \(String(describing: $0.3))")
                return $0.0 != "" && $0.1 == true && $0.2 == true && $0.3 == true
            }
            
            .eraseToAnyPublisher()
    }

    var cancellable: Set<AnyCancellable>
    /* initialize Some Usecase or AppState */
    
    init(textFieldWithDecimalLimitable: TextFieldLimitable, cancellable: Set<AnyCancellable>) {
        self.textFieldWithDecimalLimitable = textFieldWithDecimalLimitable
        self.cancellable = cancellable
        switch1EnabledPublisher
            .sink(receiveValue: { [weak self] values in
            guard let self = self else { return }
                self.switch1Enabled = values
        }).store(in: &self.cancellable)
        
        switch2EnabledPublisher
            .sink(receiveValue: { [weak self] values in
            guard let self = self else { return }
                self.switch2Enabled = values
        }).store(in: &self.cancellable)
        
        switch3EnabledPublisher
            .sink(receiveValue: { [weak self] values in
            guard let self = self else { return }
                self.switch3Enabled = values
        }).store(in: &self.cancellable)
        
        enableButtonPublisher
            .sink(receiveValue: { [weak self] values in
                guard let self = self else { return }
                self.enableButton = values
            }).store(in: &self.cancellable)
        
        
        
        
    }
    
    func viewDidLoad() { }
    
    func viewDidAppear() { }
    
    func viewDidDisappear() { }
    
    func viewWillAppear() { }
    
    func viewWillDisappear() { }
    
    // extra Business logic
    var cursorPosition: Int? = 0
}
