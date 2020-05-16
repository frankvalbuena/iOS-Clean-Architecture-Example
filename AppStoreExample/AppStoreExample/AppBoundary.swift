//
//  AppComponent.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 4/05/20.
//  Copyright © 2020 Frank Valbuena. All rights reserved.
//

import Foundation
import Boundaries
import UIKit

final class AppBoundary: RootBoundary {
    typealias Subboundaries = BoundaryList
        .Add<Entity>
        .Add<UseCase>
        .Add<Service>
        .Add<ViewModel>
        .Add<View>
    
    var rootViewController: InputPort<UIViewController?> {
        return makeInputPort(implementation: view.rootViewController)
    }
    
    lazy var entities: Entity.Resolved = {
        return resolver(for: Entity.self).resolved()
    }()
    
    lazy var useCases: UseCase.Resolved = {
        return resolver(for: UseCase.self)
            .resolve(plugin: services)
            .resolve(dependency: entities)
            .resolved()
    }()
    
    lazy var services: Service.Resolved = {
        return resolver(for: Service.self).resolved()
    }()
    
    lazy var viewModels: ViewModel.Resolved = {
        return resolver(for: ViewModel.self)
            .resolve(dependency: useCases)
            .resolved()
    }()
    
    lazy var view: View.Resolved = {
        return resolver(for: View.self)
            .resolve(dependency: viewModels)
            .resolved()
    }()
}
