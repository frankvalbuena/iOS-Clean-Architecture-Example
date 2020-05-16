//
//  SyncAppDataTest.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/4/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import XCTest
@testable import AppStoreExample

final class SyncAppDataTest: XCTestCase {
    var service: MockAppStoreService!
    var repository: MockAppsRepository!
    var sut: SyncAppDataImpl!
    
    override func setUpWithError() throws {
        service = MockAppStoreService()
        repository = MockAppsRepository()
        sut = SyncAppDataImpl(repository: repository, service: service)
    }
    
    override func tearDownWithError() throws {
        service = nil
        repository = nil
        sut = nil
    }
    
    func testFailure() {
        service.mockResponse = .notConnectedToInternet
        sut { result in
            if case .failure = result {
                print("Good status")
            } else {
                XCTFail("Sync is not detecting failures on the service")
            }
        }
    }
    
    func testNotInternetConnection() {
        service.mockResponse = .notConnectedToInternet
        sut { (result) in
            switch result {
            case .failure(error: .notInternetConnection):
                break
            default:
                XCTFail("Sync is not detecting lack of internet connection")
            }
        }
    }
    
    func testRightSync() {
        let mockApp = RawAppData(appstoreID: "123456",
                                 shortName: "Short Name",
                                 detailName: "Complete Name",
                                 artist: "Frank Valbuena",
                                 category: "Mock Apps",
                                 releaseDate: "1/4/17",
                                 summary: "This is a Mock app for testing",
                                 rights: "All the rights",
                                 bannerURL: URL(string: "http://mock.com/mockBanner.png"),
                                 iconURL: URL(string: "http://mock.com/mockIcon.png"),
                                 rank: 0)
        service.mockResponse = .success(apps: [mockApp])
        sut { [weak self] result in
            guard let self = self else {
                XCTFail("This test is sync given that mocks answer sync")
                return
            }
            if case .success = result {
                XCTAssertTrue(self.sut.hasCachedData, "Data needs to be cached")
                XCTAssertEqual(self.repository.listAllApps().count, 1, "Mock App Saved")
                XCTAssertTrue(self.repository.removeAllAppsCalled,
                              "Old Data needs to be removed, otherwise rank could be messed up")
            } else {
                XCTFail("Sync is not synching data correctly")
            }
        }
    }
}
