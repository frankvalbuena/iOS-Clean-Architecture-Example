//
//  UseCaseGateway.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/3/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import Foundation
import Boundaries

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
