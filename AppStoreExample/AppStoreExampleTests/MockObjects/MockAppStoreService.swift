//
//  MockAppStoreService.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

class MockAppStoreService: AppStoreService {
    let mockResponse: AppStoreResponse
    var serviceCalled: Bool = false
    
    init(mockResponse: AppStoreResponse) {
        self.mockResponse = mockResponse
    }
    
    func retrieveTopFreeApps(count: Int, completion: @escaping (AppStoreResponse) -> Void) {
        serviceCalled = true
        completion(mockResponse)
    }
}
