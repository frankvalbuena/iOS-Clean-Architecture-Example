//
//  SyncAppData.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/3/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import Foundation

enum SyncResult {
    enum Error {
        case unknown
        case notInternetConnection
    }
    
    case success
    case failure(error: Error)
}

protocol SyncAppData {
    var lastSyncResult: SyncResult? { get }
    var hasCachedData: Bool { get }
    
    func callAsFunction(_ completion: @escaping (SyncResult) -> ())
}
