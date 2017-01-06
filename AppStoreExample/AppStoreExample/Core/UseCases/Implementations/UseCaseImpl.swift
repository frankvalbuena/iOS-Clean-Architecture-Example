//
//  UseCaseImpl.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

class UseCaseImpl {
    let repository: AppsRepository
    let service: AppStoreService
    
    required init(repository: AppsRepository, service: AppStoreService) {
        self.repository = repository
        self.service = service
    }
}
