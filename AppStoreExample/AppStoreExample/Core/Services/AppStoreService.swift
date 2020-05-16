//
//  AppStoreService.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/3/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import Foundation

enum AppStoreResponse {
    case failure
    case notConnectedToInternet
    case success(apps: [AppData])
}

protocol AppStoreService {
    func retrieveTopFreeApps(count: Int, completion: @escaping (AppStoreResponse) -> Void)
}
