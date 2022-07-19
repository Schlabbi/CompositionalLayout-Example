//
//  Section.swift
//  CollectionView-CompositionalLayout
//
//  Created by Jonas Schlabertz on 09.06.22.
//

import Foundation
import UIKit

enum Section: Int, CaseIterable, Hashable {
    
    case list
    case singleItemContinuous
    case singleItemGroupPaging
    case singleItemGroupPagingCentered
    case multiItemContinuous
    case multiItemGroupPaging
    case multiItemGroupPagingCentered
    case interactiveSliderSection
    case flowLayout
    
    var randomItem: Item {
        return .item(UUID())
    }
    
    var count: Int {
        switch self {
        case .flowLayout,
             .list:
            return 10
        default:
            return 50
        }
    }
    
    var title: String {
        switch self {
        case .flowLayout:
            return "Flow Layout"
        case .list:
            return "List Section"
        case .singleItemContinuous:
            return "Single Item Slider (Continuous)"
        case .singleItemGroupPaging:
            return "Single Item Slider (Paging)"
        case .singleItemGroupPagingCentered:
            return "Single Item Slider (Paging Centered)"
        case .multiItemContinuous:
            return "Multi Item Slider (Continuous)"
        case .multiItemGroupPaging:
            return "Multi Item Slider (Paging)"
        case .multiItemGroupPagingCentered:
            return "Multi Item Slider (Paging Centered)"
        case .interactiveSliderSection:
            return "Interactive Slider Section (Paging Centered)"
        }
    }
    
}
