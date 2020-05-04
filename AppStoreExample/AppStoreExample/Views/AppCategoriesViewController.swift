//
//  AppCategoriesViewController.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/6/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation
import UIKit

final class AppCategoriesViewController: UITableViewController {
    static let cellId = "CategoryCellId"
    let viewModel = AppCategoriesViewModel(locator: UseCaseLocator.defaultLocator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: Configuration

private extension AppCategoriesViewController {
    func configureUI() {
        self.navigationItem.title = "Categories"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                 target: self,
                                                                 action: #selector(AppCategoriesViewController.onDismiss))
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: type(of: self).cellId)
        self.clearsSelectionOnViewWillAppear = false
        if let row = viewModel.categories.firstIndex(of: viewModel.selectedCategory ?? type(of: viewModel).allApps) {
            self.tableView.selectRow(at: IndexPath(row: row, section: 0),
                                     animated: false,
                                     scrollPosition: .none)
        }
    }
    
    @objc func onDismiss() {
       self.dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableViewDatasource

extension AppCategoriesViewController {
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellId)!
        let isSelected = self.tableView.indexPathForSelectedRow == indexPath
        
        cell.textLabel?.text = viewModel.categories[indexPath.row]
        cell.accessoryType =  isSelected ? .checkmark : .none
        cell.selectionStyle = isSelected ? .none : .gray
        return cell
    }
}

// MARK: UITableViewDelegate

extension AppCategoriesViewController {
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedCategory = viewModel.categories[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        onDismiss()
    }
}
