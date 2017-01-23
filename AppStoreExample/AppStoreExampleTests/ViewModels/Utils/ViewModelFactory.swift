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
                                appId: String,
                                imageDownloaderResponse: MockImageDownloader.DownloaderResult,
                                appDownloaderResponse: AppStoreResponse) -> T?
}

struct ViewModelFactory: ViewModelFactoryProtocol {
    
    static let sportID = "123456"
    static let sportCategory = "Sport Apps"
    static let mockID = "1234567"
    static let mockCategory = "Mock Apps"
    
    static let demoApp = RawAppData(appstoreID: ViewModelFactory.mockID,
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
    
    static let demoApp2 = RawAppData(appstoreID: ViewModelFactory.sportID,
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
    
    private init() {}
    
    static func createViewModel<T>(ofType type: T.Type,
                                    appId: String = ViewModelFactory.mockID,
                                    imageDownloaderResponse: MockImageDownloader.DownloaderResult = .sucess,
                                    appDownloaderResponse: AppStoreResponse = .success(apps:[ViewModelFactory.demoApp])) -> T? {
        
        let service = MockAppStoreService(mockResponse: appDownloaderResponse)
        let repository = MockAppsRepository()
        let locator = UseCaseLocator(repository: repository, service: service)
        
        if type == AppSyncViewModel.self {
            return AppSyncViewModel(locator: locator) as? T
        } else if type == AppListViewModel.self {
            syncApps(withLocator: locator)
            return AppListViewModel(locator: locator) as? T
        } else if type == AppCategoriesViewModel.self {
            syncApps(withLocator: locator)
            return AppCategoriesViewModel(locator: locator) as? T
        } else if type == AppThumbnailViewModel.self {
            return AppThumbnailViewModel(thumbnail: demoAppDTO(),
                                         imageDownloaderService: MockImageDownloader(result: imageDownloaderResponse)) as? T
        } else {
            syncApps(withLocator: locator)
            return AppDetailsViewModel(appID: appId,
                                       locator: locator,
                                       imageDownloader: MockImageDownloader(result: imageDownloaderResponse)) as? T
        }
    }
    
}

private extension ViewModelFactory {
    static func syncApps(withLocator locator: UseCaseLocator) {
        let syncImplementator = locator.getUseCase(ofType: SyncAppData.self)
        syncImplementator?.sync({ (result) in})
    }
    
    static func demoAppDTO () -> AppThumbnailDTO {
        return AppThumbnailDTO(appstoreID: demoApp.appstoreID,
                                              name: demoApp.shortName,
                                              iconURL: demoApp.iconURL)
    }
}
