//
//  GetAppDetailsTest.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/4/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import XCTest
@testable import AppStoreExample

final class GetAppDetailsTest: XCTestCase {
    var repository: MockAppsRepository!
    var sut: GetAppDetailsImpl!
    
    override func setUpWithError() throws {
        repository = MockAppsRepository()
        sut = GetAppDetailsImpl(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        sut = nil
    }
    
    func testGetDetails() {
        let mockApp = buildApp(appstoreId: "1", rank: 1)
        
        let save = expectation(description: "Saving apps")
        repository.save(apps: [mockApp]) { [weak self] _ in
            guard let self = self else {
                XCTFail("Self was deallocated")
                return
            }
            let details = self.sut(appstoreId: "1")
            
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
