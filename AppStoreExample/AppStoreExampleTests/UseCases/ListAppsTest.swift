//
//  ListAppsTest.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/4/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import XCTest
@testable import AppStoreExample

class ListAppsTest: XCTestCase {
    func testListAllApps() {
        let mockRepository = MockAppsRepository()
        let app1 = buildApp(appstoreId: "1", rank: 1)
        let app2 = buildApp(appstoreId: "2", rank: 2)
        
        let save = expectation(description: "Saving apps")
        mockRepository.save(apps: [app1, app2]) { _ in
            let listedApps = ListAppsImpl(repository: mockRepository).listAllApps()
            
            XCTAssertEqual(listedApps.count, 2, "Two Mock Saved")
            XCTAssertEqual(listedApps.first!.appstoreID, app1.appstoreID, "App 1 comes first")
            XCTAssertEqual(listedApps.first!.name, app1.shortName, "input must match output")
            XCTAssertEqual(listedApps.first!.iconURL, app1.iconURL, "input must match output")
            save.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testListAppsByCategory() {
        let mockRepository = MockAppsRepository()
        let app1 = buildApp(appstoreId: "1", rank: 1, category: "Category A")
        let app2 = buildApp(appstoreId: "2", rank: 2, category: "Category A")
        let app3 = buildApp(appstoreId: "3", rank: 3, category: "Category B")
        
        let save = expectation(description: "Saving apps")
        mockRepository.save(apps: [app1, app2, app3]) { _ in
            let categoryA = ListAppsImpl(repository: mockRepository).listApps(byCategory: "Category A")
            let categoryB = ListAppsImpl(repository: mockRepository).listApps(byCategory: "Category B")
            
            XCTAssertEqual(categoryA.count, 2, "Two Mocks saved for Category A")
            XCTAssertEqual(categoryA.first!.appstoreID, app1.appstoreID, "App 1 comes first")
            XCTAssertEqual(categoryB.count, 1, "Single mock saved for Category B")
            XCTAssertEqual(categoryB.first!.appstoreID, app3.appstoreID, "App 3 is of type B")
            save.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}

private extension ListAppsTest {
    func buildApp(appstoreId: String, rank: Int, category: String = "Mock category") -> AppData {
        return RawAppData(appstoreID: appstoreId,
                          shortName: "Short Name",
                          detailName: "Complete Name",
                          artist: "Frank Valbuena",
                          category: category,
                          releaseDate: "1/4/17",
                          summary: "This is a Mock app for testing",
                          rights: "All the rights",
                          bannerURL: URL(string: "http://mock.com/mockBanner.png"),
                          iconURL: URL(string: "http://mock.com/mockIcon.png"),
                          rank: rank)
    }
}
