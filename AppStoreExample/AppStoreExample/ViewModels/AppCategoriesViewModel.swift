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
    
    private let listCategories: ListCategories
    
    let title: String = "Categories"
    lazy var categories: [String] = {
        return [type(of: self).allApps] + listCategories.listAll()
    }()
    var selectedCategory: String? {
        didSet {
            if selectedCategory == type(of: self).allApps {
                selectedCategory = nil
            }
            
            onDidChangeSelectedCategory?(selectedCategory)
        }
    }
    var onDidChangeSelectedCategory: ((String?) -> Void)? = nil
    
    init(listCategories: ListCategories,
         selectedCategory: String?,
         onDidChangeSelectedCategory: ((String?) -> Void)?)
    {
        self.listCategories = listCategories
        self.selectedCategory = selectedCategory
        self.onDidChangeSelectedCategory = onDidChangeSelectedCategory
    }
}
