//
//  AppCategoriesViewModelTest.swift
//  AppStoreExample
//
//  Created by eli on 1/17/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import XCTest
@testable import AppStoreExample

class AppCategoriesViewModelTest: XCTestCase {
    
    var appCategoriesVM: AppCategoriesViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShoulListCategories() {
        appCategoriesVM = ViewModelFactory.createViewModel(ofType: AppCategoriesViewModel.self)
        XCTAssert(appCategoriesVM.categories.count == 2, "Categories listed are wrong!")
    }
    
    func testShouldListOnlyMockCategory() {
        appCategoriesVM = ViewModelFactory.createViewModel(ofType: AppCategoriesViewModel.self)
        XCTAssert(appCategoriesVM.categories.last == ViewModelFactory.mockCategory, "Mock Category was not listed")
    }
    
}
