//
//  GetAppDetailsImp.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/4/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import Foundation

final class GetAppDetailsImpl: GetAppDetails {
    private let repository: AppsRepository
    
    init(repository: AppsRepository) {
        self.repository = repository
    }
    
    func callAsFunction(appstoreId: String) -> AppDetailsDTO? {
        guard let app = repository.findApp(appstoreId: appstoreId) else {
            return nil
        }
        
        return AppDetailsDTO(appstoreID: app.appstoreID,
                             name: app.detailName,
                             artist: app.artist,
                             category: app.category,
                             releaseDate: app.releaseDate,
                             summary: app.summary,
                             rights: app.rights,
                             bannerURL: app.bannerURL)
    }
}
