//
//  GetAppDetailsTest.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import XCTest
@testable import AppStoreExample

class GetAppDetailsTest: XCTestCase {
    func testGetDetails() {
        let mockService = MockAppStoreService(mockResponse: .failure)
        let mockRepository = MockAppsRepository()
        let mockApp = buildApp(appstoreId: "1", rank: 1)
        
        let save = expectation(description: "Saving apps")
        mockRepository.save(apps: [mockApp]) { _ in
            let details = GetAppDetailsImpl(repository: mockRepository, service: mockService).getDetails(appstoreId: "1")
            
            XCTAssertFalse(mockService.serviceCalled, "GetAppDetails Use Case ALWAYS should use cached data")
            
            XCTAssertNotNil(details)
            XCTAssertEqual(details!.appstoreID, mockApp.appstoreID, "App 1 comes first")
            XCTAssertEqual(details!.name, mockApp.detailName, "input must match output")
            XCTAssertEqual(details!.bannerURL, mockApp.bannerURL, "input must match output")
            XCTAssertEqual(details!.artist, mockApp.artist, "input must match output")
            XCTAssertEqual(details!.category, mockApp.category, "input must match output")
            XCTAssertEqual(details!.releaseDate, mockApp.releaseDate, "input must match output")
            XCTAssertEqual(details!.rights, mockApp.rights, "input must match output")
            XCTAssertEqual(details!.summary, mockApp.summary, "input must match output")
            
            save.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}

private extension GetAppDetailsTest {
    func buildApp(appstoreId: String, rank: Int, category: String = "Mock category") -> AppData {
        return RawAppData(appstoreID: appstoreId,
                          shortName: "Short Name",
                          detailName: "Complete Name",
                          artist: "Francisco Valbuena",
                          category: category,
                          releaseDate: "1/4/17",
                          summary: "This is a Mock app for testing",
                          rights: "All the rights",
                          bannerURL: URL(string: "http://mock.com/mockBanner.png"),
                          iconURL: URL(string: "http://mock.com/mockIcon.png"),
                          rank: rank)
    }
}
