//
//  MySelectionBottomSheet.swift
//  CombineWithMVVMExample
//
//  Created by James Kong on 18/7/2022.
//

import Foundation
import PanModal
import UIKit
import Combine

class MySelectionBottomSheet: UITableViewController {
    private var cancellable = Set<AnyCancellable>()
    weak var viewModel: MainViewModelType!
    init(viewModel: MainViewModelType) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var _members: [UserGroupMemberPresentable]?
    var members: [UserGroupMemberPresentable] {
        _members ?? []
    }

    var isShortFormEnabled = true

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    let headerView = UserGroupHeaderView()

    let headerPresentable = UserGroupHeaderPresentable.init(handle: "ios-engs", description: "iOS Engineers", memberCount: 10)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        viewModel?.outputs.options2.sink(receiveValue: { [weak self] values in
            guard let self = self else { return }
            self._members = values
            self.tableView.reloadData()
        }).store(in: &cancellable)
    }

    // MARK: - View Configurations

    func setupTableView() {

        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1137254902, blue: 0.1294117647, alpha: 1)
        tableView.register(UserGroupMemberCell.self, forCellReuseIdentifier: "cell")

    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserGroupMemberCell
            else { return UITableViewCell() }

        cell.configure(with: members[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.configure(with: headerPresentable)
        return headerView
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
}

extension MySelectionBottomSheet: PanModalPresentable {
    // MARK: - Pan Modal Presentable

    var panScrollable: UIScrollView? {
        return tableView
    }

    var shortFormHeight: PanModalHeight {
        return isShortFormEnabled ? .contentHeight(300.0) : longFormHeight
    }

    var scrollIndicatorInsets: UIEdgeInsets {
        let bottomOffset = 0
        return UIEdgeInsets(top: headerView.frame.size.height, left: 0, bottom: CGFloat(bottomOffset), right: 0)
    }

    var anchorModalToLongForm: Bool {
        return false
    }

    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        let location = panModalGestureRecognizer.location(in: view)
        return headerView.frame.contains(location)
    }

    func willTransition(to state: PanModalPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state
            else { return }

        isShortFormEnabled = false
        panModalSetNeedsLayoutUpdate()
    }
    
    var panModalBackgroundColor: UIColor {
        UIColor.init(white: 1, alpha: 0)
    }
    
}

