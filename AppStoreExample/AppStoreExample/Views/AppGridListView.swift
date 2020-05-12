//
//  AppGridListView.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/5/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Cell

final class AppGridListViewCell: UICollectionViewCell, AppListCell {
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var iconImageView: UIImageView?
}

// MARK: - AppGridListView

final class AppGridListView: UICollectionView {
    fileprivate static let cellId = "AppListCellID"
    weak var listDelegate: AppListViewDelegate?
    
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
}

// MARK: - Configuration

private extension AppGridListView {
    func configure() {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 105, height: 105)
        layout.scrollDirection = .vertical
        self.collectionViewLayout = layout
        
        let nib = UINib(nibName: "AppGridListViewCell", bundle: nil)
        register(nib, forCellWithReuseIdentifier: AppGridListView.cellId)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .white
    }
}

// MARK: - AppListView

extension AppGridListView: AppListView {
    func cell(atIndex index: Int) -> AppListCell? {
        return cellForItem(at: IndexPath(row: index, section: 0)) as? AppGridListViewCell
    }
    
    func reloadData(animated: Bool) {
        if animated {
            UIView.transition(with: self,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: UICollectionView.reloadData(self),
                              completion: nil)
        } else {
            reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension AppGridListView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listDelegate?.numberOfCells() ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppGridListView.cellId,
                                                      for: indexPath)
        
        listDelegate?.configure(cell: cell as! AppGridListViewCell, atIndex: indexPath.row)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension AppGridListView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        listDelegate?.didSelect(cell: collectionView.cellForItem(at: indexPath) as! AppGridListViewCell,
                                atIndex: indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
        return true
    }
}
