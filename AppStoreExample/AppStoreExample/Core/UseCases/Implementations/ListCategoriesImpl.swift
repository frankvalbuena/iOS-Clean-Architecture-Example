//
//  ListCategoriesImpl.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/4/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import Foundation

final class ListCategoriesImpl: ListCategories {
    private let repository: AppsRepository
    
    init(repository: AppsRepository) {
        self.repository = repository
    }
    
    func callAsFunction() -> [String] {
        return repository.listCategories()
    }
}
