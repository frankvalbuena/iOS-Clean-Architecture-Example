//
//  AppThumbnailViewModelTest.swift
//  AppStoreExample
//
//  Created by eli on 1/17/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import XCTest
@testable import AppStoreExample

class AppThumbnailViewModelTest: XCTestCase {
    
    var appThumbnailVM: AppThumbnailViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNotLoadData() {
        appThumbnailVM = ViewModelFactory.createViewModel(ofType: AppThumbnailViewModel.self,
                                                          imageDownloaderResponse: .failure(errorMessage: "Resource not found"))
        appThumbnailVM.loadData()
        XCTAssert(appThumbnailVM.icon == appThumbnailVM.placeholderIcon)
    }
    
    func testShouldLoadData() {
        appThumbnailVM = ViewModelFactory.createViewModel(ofType: AppThumbnailViewModel.self,
                                                          imageDownloaderResponse: .sucess)
        appThumbnailVM.loadData()
        XCTAssert(appThumbnailVM.icon != appThumbnailVM.placeholderIcon)
    }
    
}
