//
//  AppSyncViewController.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/5/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation
import UIKit

final class AppSyncViewController: UIViewController {
    @IBOutlet weak var errorLabel: UILabel?
    @IBOutlet weak var retryButton: UIButton?
    @IBOutlet weak var retryContainerView: UIView?
    
    private let viewModel: AppSyncViewModel
    private let appList: View.AppList
    
    init?(viewModel: AppSyncViewModel, appList: View.AppList, coder: NSCoder) {
        self.viewModel = viewModel
        self.appList = appList
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(viewModel:coder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBinding()
        viewModel.startSync()
    }
    
    @IBAction func onRetry() {
        viewModel.startSync()
    }
}

private extension AppSyncViewController {
    func configureUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        retryButton?.layer.borderColor = UIColor.darkGray.cgColor
        retryButton?.layer.borderWidth = 1.0
        retryButton?.layer.cornerRadius = 3.0
    }
    
    func configureBinding() {
        viewModel.onDidChangeState = {
            [weak self] state in
           self?.onDidChange(state: state)
        }
    }
    
    func onDidChange(state: AppSyncViewModel.State) {
        switch state {
        case .finish(errorMessage: .none):
            self.goToAppList()
        case .finish(.some(let errorMessage)):
            retryContainerView?.isHidden = false
            errorLabel?.text = errorMessage
            break
        case .syncing:
            self.retryContainerView?.isHidden = true
        case .idle:
            break
        }
    }
    
    func goToAppList() {
        guard let appList = self.appList(configuration: ()) else {
            return
        }
        self.navigationController?.pushViewController(appList, animated: true)
    }
}
