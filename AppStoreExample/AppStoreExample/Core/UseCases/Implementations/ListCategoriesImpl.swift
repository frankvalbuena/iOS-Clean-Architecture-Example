//
//  ListCategoriesImpl.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

class ListCategoriesImpl: UseCaseImpl, ListCategories {
    func listAll() -> [String] {
        return repository.listCategories()
    }
}
