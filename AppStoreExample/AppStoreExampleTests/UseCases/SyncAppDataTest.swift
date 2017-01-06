//
//  SyncAppDataTest.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import XCTest
@testable import AppStoreExample

class SyncAppDataTest: XCTestCase {
    func testFailure() {
        sync(withResponse: .failure) { (_, result) in
            if case .failure = result {
                print("Good status")
            } else {
                XCTFail("Sync is not detecting failures on the service")
            }
        }
    }
    
    func testNotInternetConnection() {
        sync(withResponse: .notConnectedToInternet) { (_, result) in
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
                                 artist: "Francisco Valbuena",
                                 category: "Mock Apps",
                                 releaseDate: "1/4/17",
                                 summary: "This is a Mock app for testing",
                                 rights: "All the rights",
                                 bannerURL: URL(string: "http://mock.com/mockBanner.png"),
                                 iconURL: URL(string: "http://mock.com/mockIcon.png"),
                                 rank: 0)
        sync(withResponse: .success(apps: [mockApp])) { (useCase, result) in
            if case .success = result {
                let repository = useCase.repository as! MockAppsRepository
                
                XCTAssertTrue(useCase.hasCachedData, "Data needs to be cached")
                XCTAssertEqual(useCase.repository.listAllApps().count, 1, "Mock App Saved")
                XCTAssertTrue(repository.removeAllAppsCalled, "Old Data needs to be removed, otherwise rank could be messed up")
            } else {
                XCTFail("Sync is not synching data correctly")
            }
        }
    }
}

private extension SyncAppDataTest {
    func sync(withResponse response: AppStoreResponse, completion: @escaping (SyncAppDataImpl, SyncResult) -> Void) {
        let service = MockAppStoreService(mockResponse: response)
        let repository = MockAppsRepository()
        let syncUseCase = SyncAppDataImpl(repository: repository, service: service)
        
        syncUseCase.sync { result in
            completion(syncUseCase, result)
        }
    }
}
