//
//  SyncAppDataImpl.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

final class SyncAppDataImpl: UseCaseImpl, SyncAppData {
    static var lastSyncResult: SyncResult? = nil
    static let numberOfAppsToSync: Int = 100
    
    var hasCachedData: Bool {
        return repository.lastSyncDate != nil
    }
    
    var lastSyncResult: SyncResult? {
        return SyncAppDataImpl.lastSyncResult
    }
    
    func sync(_ completion: @escaping (SyncResult) -> ()) {
        let repository = self.repository
        func onDidComplete(result: SyncResult) {
            SyncAppDataImpl.lastSyncResult = result
            completion(result)
        }
        
        service.retrieveTopFreeApps(count: SyncAppDataImpl.numberOfAppsToSync) {
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
