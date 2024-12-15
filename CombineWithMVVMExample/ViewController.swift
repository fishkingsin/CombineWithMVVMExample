//
//  ViewController.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 18/7/2022.
//

import UIKit
import Combine
class ViewController: UIViewController {
    var cancellable: Set<AnyCancellable> = []
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let cancellable = Set<AnyCancellable>()
        let mainViewController = MainViewController(viewModel: MainViewModel(textFieldWithDecimalLimitable: DefaultTextFieldWithDecimalLimitable(), cancellable: cancellable), cancellable: cancellable)
        self.addChild(mainViewController)
        self.view.addSubview(mainViewController.view)
        mainViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            mainViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mainViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        mainViewController.didMove(toParent: self)
    }

    
    
}

