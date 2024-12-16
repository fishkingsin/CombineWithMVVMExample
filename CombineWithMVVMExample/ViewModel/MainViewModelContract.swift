//
//  MainViewModelContract.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 16/12/2024.
//

import SwiftUI
import Combine

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
    func onDismissClick()
}

public protocol MainViewModelBottomSheetOutputs {
    var bottomsheetOptions: AnyPublisher<([String], String?), Never> { get}
    var selectedIdsOnBinding: Binding<[UUID]> { get }
    var showBottomSheetPublisher: AnyPublisher<Bool, Never> { get}
    var showBottomSheetOnBinding: Binding<Bool> { get }
}

public protocol MainViewModelOutputs: MainViewModelBottomSheetOutputs {
    var switch1EnabledPublisher: AnyPublisher<Bool, Never> { get }
    var switch2EnabledPublisher: AnyPublisher<Bool, Never> { get }
    var switch3EnabledPublisher: AnyPublisher<Bool, Never> { get }
    
    var switch1Enabled: Bool { get }
    var switch2Enabled: Bool { get }
    var switch3Enabled: Bool { get }
    
    var switch1ValuePublisher: AnyPublisher<Bool, Never> { get }
    var switch2ValuePublisher: AnyPublisher<Bool, Never> { get }
    var switch3ValuePublisher: AnyPublisher<Bool, Never> { get }
    var enableButton: Bool { get }
    var enableButtonPublisher: AnyPublisher<Bool, Never> { get}
//    var text: String { get }
    var textPublisher: AnyPublisher<String, Never> { get}
    var options1: AnyPublisher<[String], Never> { get}
    var selectedOption: AnyPublisher<String, Never> { get}
    var options2: [UserGroupMemberPresentable] { get }
    var options2Publisher: AnyPublisher<[UserGroupMemberPresentable], Never> { get }
    var didClickButton: AnyPublisher<Void, Never> { get}
    var progressBarVisibility: AnyPublisher<Int, Never> { get}
    
    var enable1: AnyPublisher<Bool, Never> { get}
    var enable2: AnyPublisher<Bool, Never> { get}
    var enable3: AnyPublisher<Bool, Never> { get}
    
    var textOnBinding: Binding<String> { get }
    var switch1ValueOnBinding: Binding<Bool> { get }
    var switch2ValueOnBinding: Binding<Bool> { get }
    var switch3ValueOnBinding: Binding<Bool> { get }
}
