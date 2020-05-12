//
//  View.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 4/05/20.
//  Copyright © 2020 Francisco Valbuena. All rights reserved.
//

import Foundation
import Boundaries
import UIKit

final class View: Boundary {
    typealias Dependencies = BoundaryList.Add<ViewModel>
    
    let storyboard: UIStoryboard = .init(name: "Main", bundle: nil)
    
    var rootViewController: InputPort<UIViewController?> {
        let identifier = "\(AppSyncViewController.self)"
        let syncVC = storyboard.instantiateViewController(identifier: identifier) { [weak self] coder in
            guard let self = self else { fatalError("Component must be retained") }
            return AppSyncViewController(viewModel: self.dependencies.appSyncViewModel,
                                         appList: self.appListViewController,
                                         coder: coder)
        }
        return makeInputPort(implementation: UINavigationController(rootViewController: syncVC))
    }
    
    typealias AppList = Factory<Void, UIViewController?>
    var appListViewController: AppList {
        let identifier = "\(AppListViewController.self)"
        return AppList { [weak self] in
            return self?.storyboard.instantiateViewController(identifier: identifier) { [weak self] coder in
                guard let self = self else { fatalError("Component must be retained") }
                return AppListViewController(viewModel: self.dependencies.appListViewModel,
                                             details: self.appDetailsViewController,
                                             categories: self.categoriesViewController,
                                             coder: coder)
            }
        }
    }
    
    typealias Details = Factory<ViewModel.Details, UIViewController?>
    var appDetailsViewController: Details {
        return Details { [weak self] (details) -> UIViewController in
            guard let self = self else { fatalError("Component must be retained") }
            let viewModel = self.dependencies.appDetailsViewModel(configuration: details)
            let identifier = "\(AppDetailsViewController.self)"
            let detailsVC = self.storyboard.instantiateViewController(identifier: identifier) { (coder) -> UIViewController? in
                AppDetailsViewController(viewModel: viewModel, coder: coder)
            }
            return UINavigationController(rootViewController: detailsVC)
        }
    }
    
    typealias Categories = Factory<ViewModel.Categories, UIViewController?>
    var categoriesViewController: Categories {
        return Categories { [weak self] (categories) -> UIViewController? in
            guard let self = self else { fatalError("Component must be retained") }
            let viewModel = self.dependencies.categoriesViewModel(configuration: categories)
            return AppCategoriesViewController(viewModel: viewModel)
        }
    }
}
