//
//  InMemoryAppsRepository.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

class InMemoryAppsRepository: AppsRepository {
    private var allApps: [String: AppData] = [:]
    
    var lastSyncDate: Date?
    
    func findApp(appstoreId: String) -> AppData? {
        return allApps[appstoreId]
    }
    
    func listCategories() -> [String] {
        return Array(Set(allApps.map { $0.value.category })).sorted()
    }
    
    func listAllApps() -> AnyCollection<AppData> {
        let sortedApps = allApps.map { $0.value }.sorted { $0.rank < $1.rank }
        return AnyCollection(sortedApps)
    }
    
    func listApps(byCategory category: String) -> AnyCollection<AppData> {
        let sortedAppsByCategory = allApps.map { $0.value }.filter { $0.category == category }.sorted { $0.rank < $1.rank }
        return AnyCollection(sortedAppsByCategory)
    }
    
    func removeAllApps() {
        allApps.removeAll(keepingCapacity: true)
    }
    
    func save(apps: [AppData], completion: @escaping (SaveStatus) -> Void) {
        apps.forEach { allApps[$0.appstoreID] = $0 }
        lastSyncDate = Date()
        completion(.success)
    }
}
