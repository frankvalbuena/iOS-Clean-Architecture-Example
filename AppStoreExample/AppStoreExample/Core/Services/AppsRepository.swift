//
//  AppsRepository.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/3/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

enum SaveStatus {
    case success
    case failure
}

protocol AppsRepository {
    var lastSyncDate: Date? { get }
    
    func findApp(appstoreId: String) -> AppData?
    func listCategories() -> [String]
    func listAllApps() -> AnyCollection<AppData>
    func listApps(byCategory category: String) -> AnyCollection<AppData>
    
    func removeAllApps()
    func save(apps: [AppData], completion: @escaping (SaveStatus) -> Void)
}
