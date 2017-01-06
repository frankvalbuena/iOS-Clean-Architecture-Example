//
//  AppCategoriesViewModel.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/6/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

final class AppCategoriesViewModel {
    static let allApps = "All Apps"
    fileprivate let locator: UseCaseLocatorProtocol
    
    let title: String
    lazy var categories: [String] = {
        guard let useCase = self.locator.getUseCase(ofType: ListCategories.self) else {
            return []
        }
        return [type(of: self).allApps] + useCase.listAll()
    }()
    var selectedCategory: String? = nil {
        didSet {
            if selectedCategory == type(of: self).allApps {
                selectedCategory = nil
            }
            
            onDidChangeSelectedCategory?()
        }
    }
    var onDidChangeSelectedCategory: (() -> Void)? = nil
    
    init(locator: UseCaseLocatorProtocol) {
        self.locator = locator
        self.title = "Categories"
    }
}
