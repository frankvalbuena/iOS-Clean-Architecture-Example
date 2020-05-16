//
//  AppListView.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/5/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import Foundation
import UIKit

protocol AppListCell: class {
    var nameLabel: UILabel? { get }
    var iconImageView: UIImageView? { get }
}

protocol AppListView: class {
    var listDelegate: AppListViewDelegate? { get set }
    
    func cell(atIndex: Int) -> AppListCell?
    func reloadData(animated: Bool)
}

protocol AppListViewDelegate: class {
    func numberOfCells() -> Int
    func configure(cell: AppListCell, atIndex index: Int)
    func didSelect(cell: AppListCell, atIndex index: Int)
}
