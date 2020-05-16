//
//  AppData.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/3/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import Foundation

protocol AppData {
    var appstoreID: String { get }
    var shortName: String { get }
    var detailName: String { get }
    var artist: String { get }
    var category: String { get }
    var releaseDate: String { get }
    var summary: String { get }
    var rights: String { get }
    var bannerURL: URL? { get }
    var iconURL: URL? { get }
    var rank: Int { get }
}

struct RawAppData: AppData {
    let appstoreID: String
    let shortName: String
    let detailName: String
    let artist: String
    let category: String
    let releaseDate: String
    let summary: String
    let rights: String
    let bannerURL: URL?
    let iconURL: URL?
    let rank: Int
}
