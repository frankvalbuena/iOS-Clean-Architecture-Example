//
//  AppsRepositoryTest.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import XCTest
@testable import AppStoreExample

class AppsRespositoryTest: XCTestCase {
    
    // Add here all the repositories you want to test
    let repositoriesToTest: [AppsRepository] = [InMemoryAppsRepository()]
    
    func testSaving() {
        let mockApp = buildApp(appstoreId: "123", rank: 0)
        
        save(apps: [mockApp]) { repository in
            let apps = repository.listAllApps()
            XCTAssertEqual(apps.count, 1, "Single Mock Saved")
            
            XCTAssertEqual(apps.first!.appstoreID, mockApp.appstoreID, "input must match output")
            XCTAssertEqual(apps.first!.shortName, mockApp.shortName, "input must match output")
            XCTAssertEqual(apps.first!.iconURL, mockApp.iconURL, "input must match output")
            XCTAssertEqual(apps.first!.bannerURL, mockApp.bannerURL, "input must match output")
            XCTAssertEqual(apps.first!.detailName, mockApp.detailName, "name mus be detailName")
            XCTAssertEqual(apps.first!.artist, mockApp.artist, "input must match output")
            XCTAssertEqual(apps.first!.category, mockApp.category, "input must match output")
            XCTAssertEqual(apps.first!.releaseDate, mockApp.releaseDate, "input must match output")
            XCTAssertEqual(apps.first!.rights, mockApp.rights, "input must match output")
            XCTAssertEqual(apps.first!.summary, mockApp.summary, "input must match output")
            
            XCTAssertNotNil(repository.lastSyncDate, "Sync date must be set")
        }
    }
    
    func testFindApp() {
        let mockApp = buildApp(appstoreId: "123", rank: 0)
        
        save(apps: [mockApp]) { repository in
            let foundApp = repository.findApp(appstoreId: mockApp.appstoreID)
            
            XCTAssertNotNil(foundApp, "App must exist")
            XCTAssertEqual(foundApp?.appstoreID, mockApp.appstoreID, "Must be the same imported app")
        }
    }
    
    func testListAllApps() {
        let mockApp1 = buildApp(appstoreId: "1", rank: 1)
        let mockApp2 = buildApp(appstoreId: "2", rank: 2)
        
        save(apps: [mockApp1, mockApp2]) { repository in
            let apps = repository.listAllApps()
            
            XCTAssertEqual(apps.count, 2, "Two Mock Saved")
            XCTAssertEqual(apps.first!.appstoreID, mockApp1.appstoreID, "Rank 1 comes first")
            XCTAssertEqual(apps.first!.rank, 1, "Rank 1 comes first")
            let secondApp = apps[type(of: apps).Index(1)]
            XCTAssertEqual(secondApp.appstoreID, mockApp2.appstoreID, "Rank 2 comes last")
            XCTAssertEqual(secondApp.rank, 2, "Rank 2 comes last")
        }
    }
    
    func testListByCategory() {
        let mockApp1 = buildApp(appstoreId: "1", rank: 1, category: "Category A")
        let mockApp2 = buildApp(appstoreId: "2", rank: 2, category: "Category A")
        let mockApp3 = buildApp(appstoreId: "3", rank: 3, category: "Category B")
        
        save(apps: [mockApp1, mockApp2, mockApp3]) { repository in
            let appsCategoryA = repository.listApps(byCategory: "Category A")
            
            XCTAssertEqual(appsCategoryA.count, 2, "Two Mocks on Category A")
            XCTAssertEqual(appsCategoryA.first!.appstoreID, mockApp1.appstoreID, "Rank 1 comes first")
            XCTAssertEqual(appsCategoryA[type(of: appsCategoryA).Index(1)].appstoreID, mockApp2.appstoreID, "Rank 2 comes later")
        }
    }
    
    func testListCategories() {
        let mockApp1 = buildApp(appstoreId: "1", rank: 1, category: "Category A")
        let mockApp2 = buildApp(appstoreId: "2", rank: 2, category: "Category A")
        let mockApp3 = buildApp(appstoreId: "3", rank: 3, category: "Category B")
        
        save(apps: [mockApp1, mockApp2, mockApp3]) { repository in
            let categories = repository.listCategories()
            
            XCTAssertEqual(categories, ["Category A", "Category B"])
        }
    }
    
    func testRemoveAllApps() {
        let mockApp1 = buildApp(appstoreId: "1", rank: 1)
        let mockApp2 = buildApp(appstoreId: "2", rank: 2)
        
        save(apps: [mockApp1, mockApp2]) { repository in
            XCTAssertEqual(repository.listAllApps().count, 2, "Two Mock Saved")
            repository.removeAllApps()
            XCTAssertEqual(repository.listAllApps().count, 0, "Must be empty after removing all the apps")
        }
    }
}

private extension AppsRespositoryTest {
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
    
    func save(apps: [AppData], success: @escaping (AppsRepository) -> Void) {
        repositoriesToTest.forEach { repository in
            let saving = expectation(description: "saving")
            
            repository.save(apps: apps) { result in
                if case .success = result {
                    success(repository)
                } else {
                    XCTFail("Saving failed")
                }
                
                saving.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
