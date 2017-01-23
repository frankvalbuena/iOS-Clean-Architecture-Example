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
        
        public enum ErrorMessage: String {
            case internetConnection = "Cannot connect to the AppStore, please try again later"
            case failure = "Please check your internet connection"
            case unknow = "An unknown error has occurred"
        }
        
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
            appSyncState = .finish(errorMessage:  State.ErrorMessage.unknow.rawValue)
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
            let error = !hasCachedData ? State.ErrorMessage.failure.rawValue : nil
            appSyncState = .finish(errorMessage: error)
        case .failure(error: .notInternetConnection):
            let error = !hasCachedData ? State.ErrorMessage.internetConnection.rawValue : nil
            appSyncState = .finish(errorMessage: error)
        }
    }
    
}

func ==(lhs: AppSyncViewModel.State, rhs: AppSyncViewModel.State) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle):
        return true
    case (.syncing, .syncing):
        return true
    case (let .finish(errorMessageL), let .finish(errorMessageR)):
        return errorMessageL == errorMessageR
    default:
        return false
    }
}
