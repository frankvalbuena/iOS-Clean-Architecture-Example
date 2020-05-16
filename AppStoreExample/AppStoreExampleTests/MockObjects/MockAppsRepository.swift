//
//  MockAppsRepository.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/4/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import Foundation

class MockAppsRepository: InMemoryAppsRepository {
    var removeAllAppsCalled = false
    
    override func removeAllApps() {
        super.removeAllApps()
        removeAllAppsCalled = true
    }
}
