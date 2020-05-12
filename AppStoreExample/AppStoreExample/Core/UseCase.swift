//
//  UseCaseGateway.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/3/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation
import Boundaries

protocol UseCaseLocatorProtocol {
    func getUseCase<T>(ofType type: T.Type) -> T?
}

final class UseCase: Boundary {
    struct Plugins: PluginBoundary {
        var repository: InputPort<AppsRepository>
        var service: InputPort<AppStoreService>
    }
    typealias Dependencies = BoundaryList.Add<Entity>.Add<Plugins>
    
    var getAppDetails: InputPort<GetAppDetails> {
        return makeInputPort(implementation: GetAppDetailsImpl(repository: self.dependencies.repository))
    }
    
    var listApps: InputPort<ListApps> {
        return makeInputPort(implementation: ListAppsImpl(repository: self.dependencies.repository))
        
    }
    
    var listCategories: InputPort<ListCategories> {
        return makeInputPort(implementation: ListCategoriesImpl(repository: self.dependencies.repository))
    }
    
    var syncAppData: InputPort<SyncAppData> {
        return makeInputPort(implementation: SyncAppDataImpl(repository: self.dependencies.repository,
                                                             service: self.dependencies.service))
    }
}
