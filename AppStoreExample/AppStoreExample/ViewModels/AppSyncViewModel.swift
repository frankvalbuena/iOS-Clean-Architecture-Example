//
//  AppSyncViewModel.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/4/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import Foundation

final class AppSyncViewModel {
    enum State {
        case idle
        case finish(errorMessage: String?)
        case syncing
    }
    
    var onDidChangeState: ((State) -> Void)? = nil
    fileprivate(set) var appSyncState: State = .idle {
        didSet { onDidChangeState?(appSyncState) }
    }
    
    private let syncAppData: SyncAppData
    
    init(syncAppData: SyncAppData) {
        self.syncAppData = syncAppData
    }
    
    func startSync() {
        appSyncState = .syncing
        syncAppData { [weak self] result in
            guard let self = self else {
                return
            }
            self.didFinishSync(result: result, hasCachedData: self.syncAppData.hasCachedData)
        }
    }
    
}

fileprivate extension AppSyncViewModel {
    func didFinishSync(result: SyncResult, hasCachedData: Bool) {
        switch result {
        case .success:
            appSyncState = .finish(errorMessage: nil)
        case .failure(error: .unknown):
            let error = !hasCachedData ? "Cannot connect to the AppStore, please try again later" : nil
            appSyncState = .finish(errorMessage: error)
        case .failure(error: .notInternetConnection):
            let error = !hasCachedData ? "Please check your internet connection" : nil
            appSyncState = .finish(errorMessage: error)
        }
    }
}
