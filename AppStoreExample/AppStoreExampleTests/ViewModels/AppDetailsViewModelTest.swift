//
//  AppDetailsViewModelTest.swift
//  AppStoreExample
//
//  Created by eli on 1/17/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import XCTest
@testable import AppStoreExample

class AppDetailsViewModelTest: XCTestCase {
    
    var appDetailVM: AppDetailsViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNotShowBanner() {
        appDetailVM = ViewModelFactory.createViewModel(ofType: AppDetailsViewModel.self,
                                                       appId: ViewModelFactory.mockID, imageDownloaderResponse: .failure(errorMessage: "Resource not found"))
        XCTAssertNil(appDetailVM.banner)
    }
    
    func testShouldShowBanner() {
        appDetailVM = ViewModelFactory.createViewModel(ofType: AppDetailsViewModel.self,
                                                       appId: ViewModelFactory.mockID, imageDownloaderResponse: .sucess)
        XCTAssertNotNil(appDetailVM.banner)
    }
    
}
