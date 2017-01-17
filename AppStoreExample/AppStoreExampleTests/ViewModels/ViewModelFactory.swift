//
//  ViewModelUtilities.swift
//  AppStoreExample
//
//  Created by Eli Pacheco on 1/16/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation
@testable import AppStoreExample

protocol ViewModelFactoryProtocol {
    static func createViewModel<T>(ofType: T.Type,
                                response: AppStoreResponse) -> T?
}

struct ViewModelFactory: ViewModelFactoryProtocol {
    
    static let sportCategory = "Sport Apps"
    static let mockCategory = "Mock Apps"
    
    static let demoApp = RawAppData(appstoreID: "123456",
                          shortName: "Short Name",
                          detailName: "Complete Name",
                          artist: "Francisco Valbuena",
                          category: ViewModelFactory.mockCategory,
                          releaseDate: "1/4/17",
                          summary: "This is a Mock app for testing",
                          rights: "All the rights",
                          bannerURL: URL(string: "http://mock.com/mockBanner.png"),
                          iconURL: URL(string: "http://mock.com/mockIcon.png"),
                          rank: 0)
    
    static let demoApp2 = RawAppData(appstoreID: "1234567",
    shortName: "Short Name 2",
    detailName: "Complete Name 2",
    artist: "El tigre Falcao",
    category: ViewModelFactory.sportCategory,
    releaseDate: "1/15/17",
    summary: "This is a Sport app for testing",
    rights: "All the rights",
    bannerURL: URL(string: "http://mock.com/mockBanner.png"),
    iconURL: URL(string: "http://mock.com/mockIcon.png"),
    rank: 1)
    
    static func createViewModel<T>(ofType type: T.Type,
                                    response: AppStoreResponse = .success(apps:[ViewModelFactory.demoApp])) -> T? {
        let service = MockAppStoreService(mockResponse: response)
        let repository = MockAppsRepository()
        let locator = UseCaseLocator(repository: repository, service: service)
        
        if type == AppSyncViewModel.self {
            return AppSyncViewModel(locator: locator) as? T
        } else if type == AppListViewModel.self {
            syncApps(withLocator: locator)
            return AppListViewModel(locator: locator) as? T
        } else {
            syncApps(withLocator: locator)
            return AppCategoriesViewModel(locator: locator) as? T
        }
    }
    
}

private extension ViewModelFactory {
    static func syncApps(withLocator locator: UseCaseLocator) {
        let syncImplementator = locator.getUseCase(ofType: SyncAppData.self)
        syncImplementator?.sync({ (result) in})
    }
}
