//
//  UseCaseGateway.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/3/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

protocol UseCaseLocatorProtocol {
    func getUseCase<T>(ofType type: T.Type) -> T?
}

class UseCaseLocator: UseCaseLocatorProtocol {
    static let defaultLocator = UseCaseLocator(repository: InMemoryAppsRepository(),
                                               service: ItunesWebService())
    
    fileprivate let repository: AppsRepository
    fileprivate let service: AppStoreService
    
    init(repository: AppsRepository, service: AppStoreService) {
        self.repository = repository
        self.service = service
    }
    
    func getUseCase<T>(ofType type: T.Type) -> T? {
        switch String(describing: type) {
        case String(describing: GetAppDetails.self):
            return buildUseCase(type: GetAppDetailsImpl.self)
        case String(describing: ListApps.self):
            return buildUseCase(type: ListAppsImpl.self)
        case String(describing: ListCategories.self):
            return buildUseCase(type: ListCategoriesImpl.self)
        case String(describing: SyncAppData.self):
            return buildUseCase(type: SyncAppDataImpl.self)
        default:
            return nil
        }
    }
}

private extension UseCaseLocator {
    func buildUseCase<U: UseCaseImpl, R>(type: U.Type) -> R? {
        return U(repository: repository, service: service) as? R
    }
}
