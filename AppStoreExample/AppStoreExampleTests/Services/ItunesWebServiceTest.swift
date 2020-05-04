//
//  AppStoreServiceTest.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/3/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import AppStoreExample

class ItunesWebServiceTest: XCTestCase {
    let hostToStub = "itunes.apple.com"
    
    func testNotInternetConnection() {
        stub(condition: isHost(hostToStub)) { _ in
            return HTTPStubsResponse(error: NSError(domain: NSURLErrorDomain,
                                                    code: NSURLErrorNotConnectedToInternet,
                                                    userInfo: nil))
        }
        let waitingForService = expectation(description: "iTunes Service Call")
        
        ItunesWebService().retrieveTopFreeApps(count: 10) { (response) in
            if case .notConnectedToInternet = response {
                print("Correct response for not connected to Internet")
            } else {
                XCTFail("It's not identifying unreachable scenarions")
            }
            waitingForService.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testWrongJSON() {
        stub(condition: isHost(hostToStub)) { _ in
            return HTTPStubsResponse(jsonObject: ["Wrong": "Data"],
                                     statusCode: 200,
                                     headers: nil)
        }
        let waitingForService = expectation(description: "iTunes Service Call")
        
        ItunesWebService().retrieveTopFreeApps(count: 10) { (response) in
            if case .failure = response {
                print("Correct reponse for Wrong JSON")
            } else {
                XCTFail("It's not handling wrong JSON")
            }
            waitingForService.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testParsing() {
        let mockAppStoreId = "1234567"
        let mockShortName = "Mock Name"
        let mockDetailName = "Mock Detail Nmae"
        let mockArtist = "Mr Mock"
        let mockRights = "Mock Rights Reserved"
        let mockCategory = "Mock Category"
        let mockSummary = "This is a Mock description"
        let mockReleaseDate = "1/3/17"
        let mockBannerURL = "http://is4.mzstatic.com/image/thumb/Purple122/v4/f7/3f/51/f73f510f-7005-211e-f7d1-4db6a979abbd/mzl.wpouhilp.png/100x100bb-85.png"
        let mockIconURL = "http://is4.mzstatic.com/image/thumb/Purple122/v4/f7/3f/51/f73f510f-7005-211e-f7d1-4db6a979abbd/mzl.wpouhilp.png/53x53bb-85.png"
        
        stub(condition: isHost(hostToStub)) { _ in
            let mockAppData: [String : Any] = [
                "im:name": ["label": mockShortName],
                "title": ["label": mockDetailName],
                "rights": ["label": mockRights],
                "im:artist": ["label": mockArtist],
                "category": ["attributes": ["term": mockCategory]],
                "im:releaseDate": ["attributes": ["label": mockReleaseDate]],
                "im:image": [["label": mockBannerURL, "attributes": ["height": "100"]],
                             ["label": mockIconURL, "attributes": ["height": "55"]]],
                "id": ["attributes": ["im:id": mockAppStoreId]],
                "summary": ["label": mockSummary]
            ]
            return HTTPStubsResponse(jsonObject: ["feed": ["entry": [mockAppData]]],
                                     statusCode: 200,
                                     headers: nil)
        }
        
        let waitingForService = expectation(description: "iTunes Service Call")
        
        ItunesWebService().retrieveTopFreeApps(count: 1) { (response) in
            if case .success(let apps) = response {
                XCTAssertEqual(apps.count, 1, "only one mock was loaded")
                XCTAssertEqual(apps.first!.appstoreID, mockAppStoreId)
                XCTAssertEqual(apps.first!.shortName, mockShortName)
                XCTAssertEqual(apps.first!.detailName, mockDetailName)
                XCTAssertEqual(apps.first!.artist, mockArtist)
                XCTAssertEqual(apps.first!.rights, mockRights)
                XCTAssertEqual(apps.first!.category, mockCategory)
                XCTAssertEqual(apps.first!.summary, mockSummary)
                XCTAssertEqual(apps.first!.releaseDate, mockReleaseDate)
                XCTAssertEqual(apps.first!.bannerURL!, URL(string: mockBannerURL))
                XCTAssertEqual(apps.first!.iconURL!, URL(string: mockIconURL))
            } else {
                XCTFail("Could not parse correctly. Debug!!")
            }
            waitingForService.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
