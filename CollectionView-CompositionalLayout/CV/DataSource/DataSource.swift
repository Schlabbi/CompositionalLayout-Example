//
//  DataSource.swift
//  CollectionView-CompositionalLayout
//
//  Created by Jonas Schlabertz on 09.06.22.
//

import UIKit
import SwiftUI

class DataSource: UICollectionViewDiffableDataSource<Section, Item> {
    
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RandomColorCell.reuseIdentifier, for: indexPath)
            let cellCasted = cell as! RandomColorCell
            
            cellCasted.fill(with: indexPath)
            
            return cellCasted
        }
        
        // Fill section titles
        supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == InteractiveBackgroundView.kind {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: InteractiveBackgroundView.reuseIdentifier,
                                                                           for: indexPath) as! InteractiveBackgroundView
                
                return view
            } else {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: SectionTitleView.reuseIdentifier,
                                                                           for: indexPath) as! SectionTitleView
                
                let section = Section(rawValue: indexPath.section)!
                
                view.fill(with: section.title)
                
                return view
            }

        }
    }
    
}
