//
//  AppTableListView.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/5/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell: AppListCell {
    var nameLabel: UILabel? { return textLabel }
    var iconImageView: UIImageView? { return imageView }
}

class AppTableListView: UITableView  {
    fileprivate static let cellId = "AppListCellID"
    weak var listDelegate: AppListViewDelegate?
    
    init(frame: CGRect) {
        super.init(frame: frame, style: .plain)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
}

// MARK: Configuration

private extension AppTableListView {
    func configure() {
        self.delegate = self
        self.dataSource = self
        self.separatorInset = .zero
        register(UITableViewCell.self, forCellReuseIdentifier: AppTableListView.cellId)
    }
}

// MARK: AppListView

extension AppTableListView: AppListView {
    func cell(atIndex index: Int) -> AppListCell? {
        return cellForRow(at: IndexPath(row: index, section: 0))
    }
    
    func reloadData(animated: Bool) {
        if animated {
            UIView.transition(with: self,
                              duration: 2,
                              options: .transitionCrossDissolve,
                              animations: UITableView.reloadData(self),
                              completion: nil)
        } else {
            reloadData()
        }
    }
}

// MARK: UITableViewDataSource

extension AppTableListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDelegate?.numberOfCells() ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppTableListView.cellId)!
        
        listDelegate?.configure(cell: cell, atIndex: indexPath.row)
        return cell
    }
}

// MARK: UITableViewDelegate

extension AppTableListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listDelegate?.didSelect(cell: tableView.cellForRow(at: indexPath)!, atIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
