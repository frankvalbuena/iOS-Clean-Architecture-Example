//
//  AppSyncViewModel.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

enum AppSyncActions {
    case idle
    case dataWasFetched(error: Error?)
    case fetchingData
}

typealias ActionStateListener = (AppSyncActions) -> Void

final class AppSyncViewModel {
    private let locator: UseCaseLocatorProtocol
    
    var appSyncStateListener: ActionStateListener? = nil
    private(set) var appSyncState: AppSyncActions {
        didSet{
            appSyncStateListener?(appSyncState)
        }
    }
    
    init(locator: UseCaseLocatorProtocol) {
        self.locator = locator
        appSyncState = .idle
    }
    
    func startSync() {
        guard let syncUseCase = locator.getUseCase(ofType: SyncAppData.self) else {
            appSyncState = .dataWasFetched(error: Utils.createError("An known error has occurred"))
            return
        }
        appSyncState = .fetchingData
        syncUseCase.sync { [weak self] result in
            self?.didFinishSync(result: result, hasCachedData: syncUseCase.hasCachedData)
        }
    }
    
    private func didFinishSync(result: SyncResult, hasCachedData: Bool) {
        switch result {
        case .success:
            appSyncState = .dataWasFetched(error: nil)
        case .failure(error: .unknown):
            let error = !hasCachedData ? Utils.createError("Cannot connect to the AppStore, please try again later") : nil
            appSyncState = .dataWasFetched(error: error)
        case .failure(error: .notInternetConnection):
            let error = !hasCachedData ? Utils.createError("Please check your internet connection") : nil
            appSyncState = .dataWasFetched(error: error)
        }
    }
    
}
