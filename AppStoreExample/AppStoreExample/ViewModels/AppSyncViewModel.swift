//
//  AppSyncViewModel.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

final class AppSyncViewModel {
    
    enum State {
        case idle
        case finish(errorMessage: String?)
        case syncing
    }
    
    private let locator: UseCaseLocatorProtocol
    
    var onDidChangeState: ((State) -> Void)? = nil
    fileprivate(set) var appSyncState: State = .idle {
        didSet { onDidChangeState?(appSyncState) }
    }
    
    init(locator: UseCaseLocatorProtocol) {
        self.locator = locator
    }
    
    func startSync() {
        guard let syncUseCase = locator.getUseCase(ofType: SyncAppData.self) else {
            appSyncState = .finish(errorMessage: "An known error has occurred")
            return
        }
        appSyncState = .syncing
        syncUseCase.sync { [weak self] result in
            self?.didFinishSync(result: result, hasCachedData: syncUseCase.hasCachedData)
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
