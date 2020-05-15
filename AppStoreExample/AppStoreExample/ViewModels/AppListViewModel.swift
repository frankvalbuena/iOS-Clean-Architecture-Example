//
//  AppListViewModel.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

final class AppListViewModel {
    var selectedCategory: String? = nil {
        didSet { updateThumbnails() }
    }
    var categoryTitle: String {
        return (selectedCategory ?? "All Apps") + " ▼"
    }
    var warningMessage: String? = nil
    var thumbnails: AnyCollection<AppThumbnailViewModel> = AnyCollection([])
    var onListDidChange: (() -> Void)? = nil
    
    private let syncAppData: SyncAppData
    private let listApps: ListApps
    
    init(syncAppData: SyncAppData, listApps: ListApps) {
        self.syncAppData = syncAppData
        self.listApps = listApps
        updateWarning()
        updateThumbnails()
    }
}

private extension AppListViewModel {
    func updateWarning() {
        guard let lastSyncResult = syncAppData.lastSyncResult else {
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
        if let selectedCategory = self.selectedCategory {
            thumbnails = AnyCollection(listApps(byCategory: selectedCategory).lazy.map {
                AppThumbnailViewModel(thumbnail: $0)
            })
        } else {
            thumbnails = AnyCollection(listApps().lazy.map {
                AppThumbnailViewModel(thumbnail: $0)
            })
        }
        onListDidChange?()
    }
}
