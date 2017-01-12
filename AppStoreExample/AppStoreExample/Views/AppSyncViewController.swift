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
    }
    
    func configureBinding() {
        viewModel.appSyncStateListener = {
            [weak self] state in
            
            guard let `self` = self else { return }
            
            switch state {
            case .dataWasFetched(let error):
                guard let message = error else {
                    self.performSegue(withIdentifier: AppSegueID.showList.rawValue, sender: self)
                    return
                }
                self.retryContainerView?.isHidden = false
                self.errorLabel?.text = message.localizedDescription
                break
            case .fetchingData:
                self.retryContainerView?.isHidden = true
            case .idle:
                break
            }
        }
    }
    
}
