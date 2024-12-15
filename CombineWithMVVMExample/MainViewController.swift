//
//  MainViewController.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 12/12/2024.
//

import Foundation

//
//  ViewController.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 18/7/2022.
//

import UIKit
import Combine
import SwiftUI
class MainViewController<ViewModel> : UIHostingController<MainView<ViewModel>> where ViewModel: MainViewModel<DefaultTextFieldWithDecimalLimitable>{
//    var textField: UITextField = {
//       let view = UITextField()
//        view.placeholder = "Enter Text"
//        var bottomLine = CALayer()
//        bottomLine.frame = CGRect(x: 0.0, y: view.frame.height - 1, width: view.frame.width, height: 1.0)
//        bottomLine.backgroundColor = UIColor.black.cgColor
//        view.borderStyle = .none
//        view.keyboardType = .decimalPad
//        view.backgroundColor = .darkGray
//        view.layer.addSublayer(bottomLine)
//        view.textColor = .white
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    var switch1: UISwitch = {
//       let view = UISwitch()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    var switch2: UISwitch = {
//       let view = UISwitch()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    var switch3: UISwitch = {
//       let view = UISwitch()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    var button: UIButton = {
//       let view = UIButton()
//        view.setTitleColor(.blue, for: .normal)
//        view.setTitleColor(.lightGray, for: .disabled)
//        view.setTitle("SHOW BOTTOM SHEET", for: .normal)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    /// Dimension and Size
    private enum Dimen {
        /* Example
         static let headerViewTopPadding = IPhoneXRelative320LayoutConstraint.value(18)
         */
    }
    
    private(set) var viewModel: ViewModel!
    
    convenience init(viewModel: ViewModel, cancellable: Set<AnyCancellable>) {
        
        self.init(rootView: MainView(viewModel: viewModel))
        self.viewModel = viewModel
        self.cancellable = cancellable
    }
    
    override init(rootView: MainView<ViewModel>) {
        super.init(rootView: rootView)
    }
 
    
    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cancellable.removeAll(keepingCapacity: false)
    }
    
    /// Combine related:  handle lifecycle of binding/subscription
    private var cancellable = Set<AnyCancellable>()
    
    /// Light or Dark Mode handling
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
//        setupNavigationBar()
//        setupViewsAndConstraints()
//        setupLayout()
//        setupLocalization()
        bindViewModel()
//        viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.inputs.viewWillAppear()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.inputs.viewDidAppear()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.inputs.viewDidDisappear()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.inputs.viewWillDisappear()
    }
    
    private func setupNavigationBar() {
        
    }
    
//    private func setupViewsAndConstraints() {
//        self.view.backgroundColor = .white
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.spacing = 8
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.addArrangedSubview(textField)
//        stackView.addArrangedSubview(switch1)
//        stackView.addArrangedSubview(switch2)
//        stackView.addArrangedSubview(switch3)
//        stackView.addArrangedSubview(button)
//        
//        scrollView.addSubview(stackView)
//        view.addSubview(scrollView)
//        
//        
//        
//        NSLayoutConstraint.activate([
//            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
//            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//            stackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        ])
//    }
    
    private func setupLayout() {
        // TODO: setup colors, textColors, backgroundColors, images
    }
    
    private func setupLocalization() {
        // TODO: get localized string from CHFLanguage.getText(key:"__KEY__", file: CHIEF_UI_STRINGS)
    }
    
    private func bindViewModel() {
        cancellable.removeAll()
        self.viewModel.outputs.textPublisher.sink { [weak self] text in
            guard self != nil else { return }
            debugPrint("text update \(text)")
        }.store(in: &cancellable)
        /*
        button.publisher(for: .touchUpInside).sink { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.inputs.onButtonClick()
        }.store(in: &cancellable)
        
//        self.viewModel.inputs.setText(text: textField.text ?? "")
//        textField.delegate = viewModel as! UITextFieldDelegate
//        textField.publisher(for: .editingChanged)
//            .map{ view in (view as? UITextField) }
//            .compactMap{ $0 }
//            .sink { [weak self] view in
//            guard let self = self else { return }
//            self.viewModel.inputs.setText(text: view.text ?? "")
//        }.store(in: &cancellable)
        
        switch1.publisher(for: .touchUpInside)
            .map{ view in (view as? UISwitch) }
            .compactMap{ $0 }
            .sink { [weak self] view in
            guard let self = self else { return }
            print("\(view)")
            self.viewModel.inputs.enable1(value: view.isOn)
        }.store(in: &cancellable)
        
        switch2.publisher(for: .touchUpInside)
            .map{ view in (view as? UISwitch) }
            .compactMap{ $0 }
            .sink { [weak self] view in
            guard let self = self else { return }
            print("\(view)")
            self.viewModel.inputs.enable2(value: view.isOn)
        }.store(in: &cancellable)
        
        switch3.publisher(for: .touchUpInside)
            .map{ view in (view as? UISwitch) }
            .compactMap{ $0 }
            .sink { [weak self] view in
            guard let self = self else { return }
            print("\(view)")
            self.viewModel.inputs.enable3(value: view.isOn)
        }.store(in: &cancellable)
        
        viewModel
            .outputs
            .switch1EnabledPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                guard let self = self else { return }
                self.switch1.isEnabled = enabled
            }.store(in: &cancellable)
        
        viewModel
            .outputs
            .switch2EnabledPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                guard let self = self else { return }
                self.switch2.isEnabled = enabled
            }.store(in: &cancellable)
        
        viewModel
            .outputs
            .switch3EnabledPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                guard let self = self else { return }
                self.switch3.isEnabled = enabled
            }.store(in: &cancellable)
        
        viewModel
            .outputs
            .switch1ValuePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                self.switch1.isOn = value
            }.store(in: &cancellable)
        
        viewModel
            .outputs
            .switch2ValuePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                self.switch2.isOn = value
            }.store(in: &cancellable)
        
        viewModel
            .outputs
            .switch3ValuePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                self.switch3.isOn = value
            }.store(in: &cancellable)
        
        
        viewModel
            .outputs
            .enable1
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                print("enableButton \(value)")
                self.switch1.isOn = value
            }.store(in: &cancellable)
        
        viewModel
            .outputs
            .enableButton
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                guard let self = self else { return }
                print("enableButton \(enabled)")
                self.button.isEnabled = enabled
            }.store(in: &cancellable)
        
        
        viewModel
            .outputs
            .didClickButton
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.presentPanModal(MySelectionBottomSheet(viewModel: self.viewModel))
            }.store(in: &cancellable)
        
        */

    }

}

