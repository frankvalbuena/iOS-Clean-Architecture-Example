//
//  GetAppDetails.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/4/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import Foundation

struct AppDetailsDTO {
    var appstoreID: String
    var name: String
    var artist: String
    var category: String
    var releaseDate: String
    var summary: String
    var rights: String
    var bannerURL: URL?
}

protocol GetAppDetails {
    func callAsFunction(appstoreId: String) -> AppDetailsDTO?
}
