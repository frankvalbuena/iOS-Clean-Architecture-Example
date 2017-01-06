//
//  AppSyncViewModel.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

final class AppSyncViewModel {
    private let locator: UseCaseLocatorProtocol
    
    var errorMessage: String? = nil
    var hasDataToContinue: Bool = false
    var onDidFinishSync: (() -> Void)? = nil
    
    init(locator: UseCaseLocatorProtocol) {
        self.locator = locator
    }
    
    func startSync() {
        guard let syncUseCase = locator.getUseCase(ofType: SyncAppData.self) else {
            errorMessage = "An known error has occurred"
            hasDataToContinue = false
            onDidFinishSync?()
            return
        }
        syncUseCase.sync { [weak self] result in
            self?.didFinishSync(result: result, hasCachedData: syncUseCase.hasCachedData)
        }
    }
}

private extension AppSyncViewModel {
    func didFinishSync(result: SyncResult, hasCachedData: Bool) {
        switch result {
        case .success:
            errorMessage = nil
            hasDataToContinue = true
            onDidFinishSync?()
        case .failure(error: .unknown):
            hasDataToContinue = hasCachedData
            errorMessage = !hasCachedData ? "Cannot connect to the AppStore, please try again later" : nil
        case .failure(error: .notInternetConnection):
            hasDataToContinue = hasCachedData
            errorMessage = !hasCachedData ? "Please check your internet connection" : nil
        }
    }
}
