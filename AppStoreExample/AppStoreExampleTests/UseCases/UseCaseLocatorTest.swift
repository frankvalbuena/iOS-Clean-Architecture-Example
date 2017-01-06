//
//  UseCaseLocatorTest.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import XCTest
@testable import AppStoreExample

class UseCaseLocatorTest: XCTestCase {
    func testCases() {
        let repository = MockAppsRepository()
        let service = MockAppStoreService(mockResponse: .failure)
        let locator = UseCaseLocator(repository: repository, service: service)
        
        XCTAssertNotNil(locator.getUseCase(ofType: GetAppDetails.self), "GetAppDetails is mandatory")
        XCTAssertNotNil(locator.getUseCase(ofType: ListApps.self), "ListApps is mandatory")
    }
}
