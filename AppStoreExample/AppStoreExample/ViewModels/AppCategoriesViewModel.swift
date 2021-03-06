//
//  AppCategoriesViewModel.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/6/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import Foundation

final class AppCategoriesViewModel {
    static let allApps = "All Apps"
    
    private let listCategories: ListCategories
    
    let title: String = "Categories"
    lazy var categories: [String] = {
        return [type(of: self).allApps] + listCategories()
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
