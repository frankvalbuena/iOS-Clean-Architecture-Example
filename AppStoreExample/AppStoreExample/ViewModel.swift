//
//  ViewModel.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 4/05/20.
//  Copyright © 2020 Frank Valbuena. All rights reserved.
//

import Foundation
import Boundaries

final class ViewModel: Boundary {
    typealias Dependencies = BoundaryList.Add<UseCase>
    
    var appListViewModel: InputPort<AppListViewModel> {
        return makeInputPort(implementation:
            AppListViewModel(
                syncAppData: self.dependencies.syncAppData,
                listApps: self.dependencies.listApps
            )
        )
    }
    
    var appSyncViewModel: InputPort<AppSyncViewModel> {
        return makeInputPort(implementation: AppSyncViewModel(syncAppData: self.dependencies.syncAppData))
    }
    
    struct Details {
        var appId: String
    }
    var appDetailsViewModel: InputPort<Factory<Details, AppDetailsViewModel>> {
        return makeInputPort(implementation: .init(construction: { [weak self] (details) -> AppDetailsViewModel in
            guard let self = self else {
                fatalError("The component must be retained")
            }
            return AppDetailsViewModel(appID: details.appId, getAppDetails: self.dependencies.getAppDetails)
        }))
    }
    
    struct Categories {
        var selectedCategory: String?
        var onDidChangeSelectedCategory: ((String?) -> Void)?
    }
    var categoriesViewModel: InputPort<Factory<Categories, AppCategoriesViewModel>> {
        return makeInputPort(implementation: .init(construction: { [weak self] (categories) -> AppCategoriesViewModel in
            guard let self = self else { fatalError("Component must be retained") }
            return .init(listCategories: self.dependencies.listCategories,
                         selectedCategory: categories.selectedCategory,
                         onDidChangeSelectedCategory: categories.onDidChangeSelectedCategory)
        }))
    }
}
