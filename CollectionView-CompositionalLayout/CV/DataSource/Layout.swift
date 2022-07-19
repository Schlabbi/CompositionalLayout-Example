//
//  Layout.swift
//  CollectionView-CompositionalLayout
//
//  Created by Jonas Schlabertz on 09.06.22.
//

import UIKit

class Layout: UICollectionViewCompositionalLayout {
    
    init(interactiveSliderHandler: @escaping (IndexPath) -> Void) {
        super.init(sectionProvider: { section, environment in
            
            let section = Section(rawValue: section)!
            
            switch section {
                
            case .flowLayout:
                return Self.setupFlowLayout(environment: environment)
            
            case .list:
                return Self.setupListLayout(environment: environment)
                
            case .singleItemContinuous:
                return Self.setupHorizontalSliderSection(environment: environment, scrollingBehaviour: .continuous)
                
            case .singleItemGroupPaging:
                return Self.setupHorizontalSliderSection(environment: environment, scrollingBehaviour: .groupPaging)
                
            case .singleItemGroupPagingCentered:
                return Self.setupHorizontalSliderSection(environment: environment, scrollingBehaviour: .groupPagingCentered)
                
            case .multiItemContinuous:
                return Self.setupHorizontalGroupSection(environment: environment, scrollingBehaviour: .continuous)
            
            case .multiItemGroupPaging:
                return Self.setupHorizontalGroupSection(environment: environment, scrollingBehaviour: .groupPaging)
                
            case .multiItemGroupPagingCentered:
                return Self.setupHorizontalGroupSection(environment: environment, scrollingBehaviour: .groupPagingCentered)
                
            case .interactiveSliderSection:
                return Self.setupInteractiveSliderSection(environment: environment, interactiveSliderHandler: interactiveSliderHandler)
                
            }
            
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - List
    
    static private func setupListLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let list: NSCollectionLayoutSection =  .list(using: .init(appearance: .plain), layoutEnvironment: environment)
        list.boundarySupplementaryItems = [setupSectionTitleLayout()]
        
        return list
    }
    
    // MARK: - Horizontal Slider Sections
    
    static private func setupHorizontalSliderSection(environment: NSCollectionLayoutEnvironment,
                                                     scrollingBehaviour: UICollectionLayoutSectionOrthogonalScrollingBehavior) -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .fractionalHeight(1))
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .absolute(200),
                                                      heightDimension: .absolute(150))
        let group: NSCollectionLayoutGroup = .horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrollingBehaviour
        section.interGroupSpacing = 15
        section.contentInsets = .init(top: 0, leading: 8, bottom: 8, trailing: 8)
        section.boundarySupplementaryItems = [setupSectionTitleLayout()]
        
        return section
    }
    
    static private func setupHorizontalGroupSection(environment: NSCollectionLayoutEnvironment,
                                                    scrollingBehaviour: UICollectionLayoutSectionOrthogonalScrollingBehavior) -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .fractionalHeight(1))
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        
        let doubleItemGroupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1/2),
                                                                heightDimension: .fractionalWidth(1/2))
        let doubleItemGroup: NSCollectionLayoutGroup = .horizontal(layoutSize: doubleItemGroupSize,
                                                                   repeatingSubitem: item,
                                                                   count: 2)
        
        let fullWidthItemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1),
                                                              heightDimension: .fractionalHeight(1/2))
        let fullWidthItem: NSCollectionLayoutItem = .init(layoutSize: fullWidthItemSize)
        
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .absolute(200), heightDimension: .absolute(200))
        let group: NSCollectionLayoutGroup = .vertical(layoutSize: groupSize, subitems: [fullWidthItem, doubleItemGroup])
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = scrollingBehaviour
        section.interGroupSpacing = 15
        section.contentInsets = .init(top: 0, leading: 8, bottom: 8, trailing: 8)
        section.boundarySupplementaryItems = [setupSectionTitleLayout()]
        
        return section
    }
    
    // Slider with interactive Background
    
    static private func setupInteractiveSliderSection(environment: NSCollectionLayoutEnvironment, interactiveSliderHandler: @escaping (IndexPath) -> Void) -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .fractionalHeight(1))
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .absolute(environment.container.effectiveContentSize.width * 0.8),
                                                      heightDimension: .absolute(150))
        let group: NSCollectionLayoutGroup = .horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 15
        section.contentInsets = .init(top: 100, leading: 8, bottom: 8, trailing: 8)
        
        let backgroundKind: String = InteractiveBackgroundView.kind
        let backgroundSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .fractionalHeight(0.3))
        let backgroundItem: NSCollectionLayoutBoundarySupplementaryItem = .init(layoutSize: backgroundSize,
                                                                                elementKind: backgroundKind,
                                                                                alignment: .top)
        backgroundItem.extendsBoundary = false
        backgroundItem.zIndex = 0
        
        section.boundarySupplementaryItems = [backgroundItem]
        
        section.visibleItemsInvalidationHandler = { visibleItems, scrollOffset, layoutEnvironment in
            let width = layoutEnvironment.container.contentSize.width
            let height = layoutEnvironment.container.contentSize.height
            let centerRect = CGRect(x: scrollOffset.x + width / 2,
                                    y: scrollOffset.y,
                                    width: 1,
                                    height: height)
            
            let visibleCells = visibleItems.filter({ $0.representedElementCategory == .cell })
            
            guard let centerIndexPath = visibleCells.first(where: { cell in
                let frame = cell.frame
                return frame.intersects(centerRect)
            })?.indexPath else {
                return
            }
            
            interactiveSliderHandler(centerIndexPath)
        }
        
        return section
    }
    
    // MARK: - Flow Layout Replica
    
    static private func setupFlowLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {        
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1/3),
                                                     heightDimension: .fractionalHeight(1))
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalWidth(1/3))
        let group: NSCollectionLayoutGroup = .horizontal(layoutSize: groupSize,
                                                         repeatingSubitem: item,
                                                         count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [setupSectionTitleLayout()]
        
        return section
    }
    
    // Supplementary Views
    
    static private func setupSectionTitleLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
        let size: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1),
                                                 heightDimension: .estimated(40))
        let item: NSCollectionLayoutBoundarySupplementaryItem = .init(layoutSize: size,
                                                                      elementKind: UICollectionView.elementKindSectionHeader,
                                                                      alignment: .top)
        
        return item
    }
    
}
