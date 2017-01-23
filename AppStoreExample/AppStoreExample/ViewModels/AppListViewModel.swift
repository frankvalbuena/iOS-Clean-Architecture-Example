//
//  AppListViewModel.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

final class AppListViewModel {
    fileprivate let locator: UseCaseLocatorProtocol
    fileprivate let imageDownloaderService: ImageDownloaderService = AlamoFireImageDownloader.defaultDownloaderWithCache()
    
    var selectedCategory: String? = nil {
        didSet { updateThumbnails() }
    }
    var categoryTitle: String {
        return (selectedCategory ?? "All Apps") + " ▼"
    }
    var warningMessage: String? = nil
    var thumbnails: AnyCollection<AppThumbnailViewModel> = AnyCollection([])
    var onListDidChange: (() -> Void)? = nil
    
    init(locator: UseCaseLocatorProtocol) {
        self.locator = locator
        updateWarning()
        updateThumbnails()
    }
}

private extension AppListViewModel {
    func updateWarning() {
        guard let sync = locator.getUseCase(ofType: SyncAppData.self),
               let lastSyncResult = sync.lastSyncResult
        else {
            return
        }
        switch lastSyncResult {
        case .success:
            warningMessage = nil
        case .failure(error: .notInternetConnection):
            warningMessage = "Not connected to internet, data can be out of date"
        case .failure(error: .unknown):
            warningMessage = "An error occurred, data can be out of date"
        }
    }
    
    func updateThumbnails() {
        guard let list = locator.getUseCase(ofType: ListApps.self) else {
            return
        }
        unowned let unownedSelf = self
        if let selectedCategory = self.selectedCategory {
            thumbnails = AnyCollection(list.listApps(byCategory: selectedCategory).lazy.map {
                AppThumbnailViewModel(thumbnail: $0, imageDownloaderService: unownedSelf.imageDownloaderService)
            })
        } else {
            thumbnails = AnyCollection(list.listAllApps().lazy.map {
                AppThumbnailViewModel(thumbnail: $0, imageDownloaderService: unownedSelf.imageDownloaderService)
            })
        }
        onListDidChange?()
    }
}

