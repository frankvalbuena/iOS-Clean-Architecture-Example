//
//  SyncAppDataImpl.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/4/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import Foundation

final class SyncAppDataImpl: SyncAppData {
    private static var lastSyncResult: SyncResult? = nil
    private static let numberOfAppsToSync: Int = 100
    
    private let repository: AppsRepository
    private let service: AppStoreService
    
    init(repository: AppsRepository, service: AppStoreService) {
        self.repository = repository
        self.service = service
    }
    
    var hasCachedData: Bool {
        return repository.lastSyncDate != nil
    }
    
    var lastSyncResult: SyncResult? {
        return SyncAppDataImpl.lastSyncResult
    }
    
    func callAsFunction(_ completion: @escaping (SyncResult) -> ()) {
        let repository = self.repository
        func onDidComplete(result: SyncResult) {
            SyncAppDataImpl.lastSyncResult = result
            completion(result)
        }
        
        service.retrieveTopFreeApps(count: Self.numberOfAppsToSync) {
            switch $0 {
            case .success(let apps):
                repository.removeAllApps()
                repository.save(apps: apps) { result in
                    switch result {
                    case .success:
                        onDidComplete(result: .success)
                    case .failure:
                        onDidComplete(result: .failure(error: .unknown))
                    }
                }
            case .notConnectedToInternet:
                onDidComplete(result: .failure(error: .notInternetConnection))
            case .failure:
                onDidComplete(result: .failure(error: .unknown))
            }
        }
    }
}
