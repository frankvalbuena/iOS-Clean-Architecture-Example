//
//  CoreDataAppsRepository.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/6/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord

public final class AppSyncDataEntity: NSManagedObject {
    @NSManaged public var a_appstoreID: String?
    @NSManaged public var a_artist: String?
    @NSManaged public var a_bannerURL: String?
    @NSManaged public var a_category: String?
    @NSManaged public var a_detailName: String?
    @NSManaged public var a_iconURL: String?
    @NSManaged public var a_releaseDate: String?
    @NSManaged public var a_rights: String?
    @NSManaged public var a_shortName: String?
    @NSManaged public var a_summary: String?
    @NSManaged public var a_rank: NSNumber?
}

extension AppSyncDataEntity: AppData {
    var appstoreID: String { return a_appstoreID! }
    var shortName: String { return a_shortName! }
    var detailName: String { return a_detailName! }
    var artist: String { return a_artist! }
    var category: String { return a_category! }
    var releaseDate: String { return a_releaseDate! }
    var summary: String { return a_summary! }
    var rights: String { return a_rights! }
    var bannerURL: URL? { return a_bannerURL != nil ? URL(string: a_bannerURL!) : nil }
    var iconURL: URL? { return a_iconURL != nil ? URL(string: a_iconURL!) : nil }
    var rank: Int { return a_rank!.intValue }
}

final class CoreDataAppsRepository: AppsRepository {
    var lastSyncDate: Date? {
        get { return UserDefaults.standard.value(forKey:"lastSyncDate") as? Date }
        set(value) { UserDefaults.standard.set(value, forKey: "lastSyncDate") }
    }
    
    init() {
        configureCoreDataStack()
    }
    
    func findApp(appstoreId: String) -> AppData? {
        return AppSyncDataEntity.mr_findFirst(with: NSPredicate(format: "a_appstoreID = %@", appstoreId))
    }
    
    func listCategories() -> [String] {
        let request = AppSyncDataEntity.mr_requestAllSorted(by: "a_category", ascending: true)
        
        request.returnsDistinctResults = true
        request.propertiesToFetch = ["a_category"]
        request.resultType = .dictionaryResultType
        
        do {
            let result = try NSManagedObjectContext.mr_default().fetch(request)
            return (result as! [NSDictionary]).map { $0["a_category"] as! String }
        } catch {
            return []
        }
    }
    
    func listAllApps() -> AnyCollection<AppData> {
        return AnyCollection((AppSyncDataEntity.mr_findAllSorted(by: "a_rank", ascending: true) as! [AppSyncDataEntity]).map { $0 as AppData })
    }
    
    func listApps(byCategory category: String) -> AnyCollection<AppData> {
        return AnyCollection((AppSyncDataEntity.mr_find(byAttribute: "a_category",
                                                        withValue: category,
                                                        andOrderBy: "a_rank",
                                                        ascending: true) as! [AppSyncDataEntity]).map { $0 as AppData })
    }
    
    func removeAllApps() {
        MagicalRecord.save(blockAndWait: { ctx in
            AppSyncDataEntity.mr_truncateAll(in: ctx)
        })
    }
    
    func save(apps: [AppData], completion: @escaping (SaveStatus) -> Void) {
        MagicalRecord.save({ (ctx) in
            for app in apps {
                let entity = AppSyncDataEntity.mr_createEntity(in: ctx)
                
                entity?.a_appstoreID = app.appstoreID
                entity?.a_artist = app.artist
                entity?.a_rights = app.rights
                entity?.a_category = app.category
                entity?.a_detailName = app.detailName
                entity?.a_shortName = app.shortName
                entity?.a_summary = app.summary
                entity?.a_releaseDate = app.releaseDate
                entity?.a_bannerURL = app.bannerURL?.absoluteString
                entity?.a_iconURL = app.iconURL?.absoluteString
                entity?.a_rank = NSNumber(integerLiteral: app.rank)
            }
        }) { [weak self] (succeed, _) in
            self?.lastSyncDate = Date()
            completion(succeed ? .success : .failure)
        }
    }
}

private extension CoreDataAppsRepository {
    func configureCoreDataStack() {
        MagicalRecord.setupCoreDataStack()
    }
}
