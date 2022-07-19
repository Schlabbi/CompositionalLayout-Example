//
//  ViewController.swift
//  CollectionView-CompositionalLayout
//
//  Created by Jonas Schlabertz on 09.06.22.
//

import UIKit

class ViewController: UICollectionViewController {
    
    lazy var dataSource: DataSource = {
        return .init(collectionView: collectionView)
    }()
    
    lazy var layout: Layout = {
        return Layout { [weak self] indexPath in
            let supplementaryViews = self!.collectionView.visibleSupplementaryViews(ofKind: InteractiveBackgroundView.kind)
            
            guard let interactiveBackgroundView = supplementaryViews.map({ $0 as? InteractiveBackgroundView }).compactMap({ $0 }).first else {
                return
            }
            
            interactiveBackgroundView.reload(with: indexPath)
        }
    }()
    
    required init?(coder: NSCoder) {
        super.init(collectionViewLayout: UICollectionViewLayout())
        collectionView.setCollectionViewLayout(layout, animated: false)
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fill()
    }
    
    private func setup() {
        // Register Interactive Slider Background View
        collectionView.register(InteractiveBackgroundView.self,
                                forSupplementaryViewOfKind: InteractiveBackgroundView.kind,
                                withReuseIdentifier: InteractiveBackgroundView.reuseIdentifier)
        
        // Register Section Title View
        collectionView.register(SectionTitleView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionTitleView.reuseIdentifier)
        // Register Cell
        collectionView.register(RandomColorCell.self, forCellWithReuseIdentifier: RandomColorCell.reuseIdentifier)
    }
    
    private func fill() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections(Section.allCases)
        
        for section in Section.allCases {
            for _ in 0..<section.count {
                let item = section.randomItem
                snapshot.appendItems([item], toSection: section)
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
