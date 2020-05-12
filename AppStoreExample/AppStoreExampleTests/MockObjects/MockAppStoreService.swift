//
//  MockAppStoreService.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

final class MockAppStoreService: AppStoreService {
    var mockResponse: AppStoreResponse!
    var serviceCalled: Bool = false
    
    init() {
    }
    
    func retrieveTopFreeApps(count: Int, completion: @escaping (AppStoreResponse) -> Void) {
        serviceCalled = true
        completion(mockResponse)
    }
}
