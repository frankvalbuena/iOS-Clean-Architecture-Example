//
//  AppListViewController.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/5/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation
import UIKit

final class AppListViewController: UIViewController {
    fileprivate let listViewModel = AppListViewModel(locator: UseCaseLocator.defaultLocator)
    
    weak var listView: AppListView?
    @IBOutlet weak var categoriesButton: UIButton?
    @IBOutlet weak var listContainerView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBinding()
    }
    
    @IBAction func onCategory() {
        let categoriesVC = AppCategoriesViewController(style: .grouped)
        
        categoriesVC.viewModel.selectedCategory = listViewModel.selectedCategory
        categoriesVC.viewModel.onDidChangeSelectedCategory = { [weak self, weak categoriesVC] in
            self?.listViewModel.selectedCategory = categoriesVC?.viewModel.selectedCategory
        }
        let nav = UINavigationController(rootViewController: categoriesVC)
        
        nav.modalPresentationStyle = .popover
        nav.preferredContentSize = CGSize(width: 500, height: 600)
        let popover = nav.popoverPresentationController
        popover?.sourceView = self.view
        popover?.sourceRect = categoriesButton!.convert(categoriesButton!.bounds, to: self.view)
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - Configuration

private extension AppListViewController {
    func configureUI() {
        guard let listContainerView = self.listContainerView else {
            return
        }
        let listView: UIView = UIDevice.current.userInterfaceIdiom == .pad ?
            AppGridListView(frame: listContainerView.bounds) :
            AppTableListView(frame: listContainerView.bounds)
        listView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        listView.translatesAutoresizingMaskIntoConstraints = true
        (listView as? AppListView)?.listDelegate = self
        listContainerView.addSubview(listView)
        self.listView = listView as? AppListView
    }
    
    func configureBinding() {
        updateUI(animated: false)
        listViewModel.onListDidChange = { [weak self] in
            self?.updateUI(animated: true)
        }
    }
    
    func updateUI(animated: Bool) {
        categoriesButton?.setTitle(listViewModel.categoryTitle, for: .normal)
        listView?.reloadData(animated: animated)
    }
}

// MARK: - AppListViewDelegate

extension AppListViewController: AppListViewDelegate {
    func numberOfCells() -> Int {
        return Int(listViewModel.thumbnails.count)
    }
    
    func configure(cell: AppListCell, atIndex index: Int) {
        let thumb = thumbnail(atIndex: index)
        
        thumb.onDidLoad = { [weak self, weak thumb, weak cell] in
            if thumb == self?.thumbnail(atIndex: index) {
                cell?.iconImageView?.image = thumb?.icon
                (cell as? UIView)?.setNeedsLayout()
            }
        }
        thumb.loadData()
        cell.iconImageView?.image = thumb.icon
        cell.iconImageView?.layer.cornerRadius = 10.0
        cell.iconImageView?.layer.masksToBounds = true
        cell.nameLabel?.text = thumb.name
        cell.nameLabel?.numberOfLines = 0
        cell.nameLabel?.minimumScaleFactor = 0.5
    }
    
    func didSelect(cell: AppListCell, atIndex index: Int) {
        // TODO: Present Detail View Controller
    }
    
    private func thumbnail(atIndex index: Int) -> AppThumbnailViewModel {
        return listViewModel.thumbnails[AnyIndex(AnyIndex(AnyIndex(index)))]
    }
}
