//
//  AppSyncViewModelTest.swift
//  AppStoreExample
//
//  Created by Eli Pacheco on 1/16/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import XCTest
@testable import AppStoreExample

class AppSyncViewModelTest: XCTestCase {    
    var syncVM: AppSyncViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShouldFinishWithoutError() {
        syncVM = ViewModelFactory.createViewModel(ofType: AppSyncViewModel.self)
        syncVM.startSync()
        XCTAssert(self.syncVM.appSyncState == .finish(errorMessage: nil), "Apps not synchonized")
    }
    
    func testShouldFinishWithInternetConnectionError() {
        syncVM = ViewModelFactory.createViewModel(ofType: AppSyncViewModel.self, response: .notConnectedToInternet)
        syncVM.startSync()
        let message = AppSyncViewModel.State.ErrorMessage.internetConnection.rawValue
        XCTAssert(syncVM.appSyncState == .finish(errorMessage: message))
    }
    
    func testShouldFinishWithFailure() {
        syncVM = ViewModelFactory.createViewModel(ofType: AppSyncViewModel.self, response: .failure)
        syncVM.startSync()
        let message = AppSyncViewModel.State.ErrorMessage.failure.rawValue
        XCTAssert(syncVM.appSyncState == .finish(errorMessage: message))
    }
    
}
