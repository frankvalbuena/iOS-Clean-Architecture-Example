//
//  ListApps.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/3/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

struct AppThumbnailDTO {
    var appstoreID: String
    var name: String
    var iconURL: URL?
}

protocol ListApps {
    func listAllApps() -> AnyCollection<AppThumbnailDTO>
    func listApps(byCategory: String) -> AnyCollection<AppThumbnailDTO>
}
