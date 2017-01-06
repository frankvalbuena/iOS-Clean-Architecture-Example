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
    let viewModel = AppSyncViewModel(locator: UseCaseLocator.defaultLocator)
    
    @IBOutlet weak var errorLabel: UILabel?
    @IBOutlet weak var retryButton: UIButton?
    @IBOutlet weak var retryContainerView: UIView?
    
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
        retryButton?.layer.borderColor = UIColor.darkGray.cgColor
        retryButton?.layer.borderWidth = 1.0
        retryButton?.layer.cornerRadius = 3.0
        retryContainerView?.isHidden = true
    }
    
    func configureBinding() {
        viewModel.onDidFinishSync = { [weak self] in
            self?.onDidFinishSync()
        }
    }
    
    func onDidFinishSync() {
        errorLabel?.text = viewModel.errorMessage
        retryContainerView?.isHidden = viewModel.hasDataToContinue
        
        if viewModel.hasDataToContinue {
            self.performSegue(withIdentifier: AppSegueID.showList.rawValue, sender: self)
        }
    }
}
