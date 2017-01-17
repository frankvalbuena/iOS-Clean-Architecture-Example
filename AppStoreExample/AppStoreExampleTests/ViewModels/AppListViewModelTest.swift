//
//  AppListViewModelTest.swift
//  AppStoreExample
//
//  Created by Eli Pacheco on 1/16/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import XCTest
@testable import AppStoreExample

class AppListViewModelTest: XCTestCase {
    
    var appListVM: AppListViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testlNotShowWarningMessage() {
        appListVM = ViewModelFactory.createViewModel(ofType: AppListViewModel.self)
        XCTAssert(appListVM.warningMessage == nil, "ViewModel can't show warning message")
    }
    
    func testShowWarnigMessageForInternetConectionError() {
        let response: AppStoreResponse = .notConnectedToInternet
        appListVM = ViewModelFactory.createViewModel(ofType: AppListViewModel.self, response: response)
        XCTAssert(appListVM.warningMessage == "Not connected to internet, data can be out of date")
    }
    
    func testShowWarningMessageForFailureError() {
        let response: AppStoreResponse = .failure
        appListVM = ViewModelFactory.createViewModel(ofType: AppListViewModel.self, response: response)
        XCTAssert(appListVM.warningMessage == "An error occurred, data can be out of date")
    }
    
    func testShouldNotUpdateThumbnails() {
        let response: AppStoreResponse = .failure
        appListVM = ViewModelFactory.createViewModel(ofType: AppListViewModel.self, response: response)
        XCTAssert(appListVM.thumbnails.count == 0)
    }
    
    func testShouldUpdateThumbnails() {
        let response: AppStoreResponse = .success(apps: [ViewModelFactory.demoApp, ViewModelFactory.demoApp2])
        appListVM = ViewModelFactory.createViewModel(ofType: AppListViewModel.self, response: response)
        XCTAssert(appListVM.thumbnails.count == 2)
    }
    
    func testNotShouldUpdateSportCategory() {
        let response: AppStoreResponse = .success(apps: [ViewModelFactory.demoApp, ViewModelFactory.demoApp2])
        appListVM = ViewModelFactory.createViewModel(ofType: AppListViewModel.self, response: response)
        appListVM.selectedCategory = "Fake category"
        XCTAssert(appListVM.thumbnails.count == 0)
    }
    
    func testShouldUpdateMockCategory() {
        let response: AppStoreResponse = .success(apps: [ViewModelFactory.demoApp, ViewModelFactory.demoApp2])
        appListVM = ViewModelFactory.createViewModel(ofType: AppListViewModel.self, response: response)
        appListVM.selectedCategory = ViewModelFactory.mockCategory
        XCTAssert(appListVM.thumbnails.count == 1)
    }
    
    func testShouldUpdateSportCategory() {
        let response: AppStoreResponse = .success(apps: [ViewModelFactory.demoApp, ViewModelFactory.demoApp2])
        appListVM = ViewModelFactory.createViewModel(ofType: AppListViewModel.self, response: response)
        appListVM.selectedCategory = ViewModelFactory.sportCategory
        XCTAssert(appListVM.thumbnails.count == 1)
    }
    
}
