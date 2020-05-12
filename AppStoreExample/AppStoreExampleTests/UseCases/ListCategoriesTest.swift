//
//  ListCategoriesTest.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import XCTest
@testable import AppStoreExample

class ListCategoriesTest: XCTestCase {
    func testListCategories() {
        let mockRepository = MockAppsRepository()
        let app1 = buildApp(appstoreId: "1", rank: 1, category: "Category A")
        let app2 = buildApp(appstoreId: "2", rank: 2, category: "Category A")
        let app3 = buildApp(appstoreId: "3", rank: 3, category: "Category B")
        
        let save = expectation(description: "Saving apps")
        mockRepository.save(apps: [app1, app2, app3]) { _ in
            let categories = ListCategoriesImpl(repository: mockRepository).listAll()
            
            XCTAssertEqual(categories, ["Category A", "Category B"])
            save.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}

private extension ListCategoriesTest {
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
