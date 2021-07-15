//
//  adsdf.swift
//  MarvelHeroes
//
//  Created by Kurro on 9/7/21.
//

import Foundation
import UIKit

final class DataSource: NSObject, UICollectionViewDataSource {

    var items: [String] = []
    
    func attach(to view: UICollectionView) {
        // Setup itself as table data source (Implementation in separated extension)
        view.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension DataSource: UICollectionViewDataSource {
    
    // Return elements count that must be displayed in table
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // Instantiate or reused (depend on position and cell type in table view), configure cell element and return it for displaying on table
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppearanceViewCell.identifier, for: indexPath) as! AppearanceViewCell
        //cell.title.text = item
        return cell
    }
    
}
