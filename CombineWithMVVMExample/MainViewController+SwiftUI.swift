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
class MainViewControllerSwiftUI<ViewModel> : UIHostingController<MainView<ViewModel>> where ViewModel: MainViewModelType {

    
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
        bindViewModel()
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

    }

}

