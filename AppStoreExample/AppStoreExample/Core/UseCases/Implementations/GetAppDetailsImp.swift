//
//  GetAppDetailsImp.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

class GetAppDetailsImpl: UseCaseImpl, GetAppDetails {
    func getDetails(appstoreId: String) -> AppDetailsDTO? {
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
