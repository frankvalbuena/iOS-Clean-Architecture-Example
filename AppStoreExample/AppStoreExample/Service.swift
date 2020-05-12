//
//  Service.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 4/05/20.
//  Copyright © 2020 Francisco Valbuena. All rights reserved.
//

import Foundation
import Boundaries

final class Service: AdapterBoundary {
    typealias PluginAdaptee = UseCase.Plugins
    
    func makePlugin() -> UseCase.Plugins {
        let repository = CoreDataAppsRepository()
        let appstoreService = ItunesWebService()
        return UseCase.Plugins(repository: makeInputPort(implementation: repository),
                               service: makeInputPort(implementation: appstoreService))
    }
}
