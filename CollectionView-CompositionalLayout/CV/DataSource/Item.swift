//
//  Item.swift
//  CollectionView-CompositionalLayout
//
//  Created by Jonas Schlabertz on 09.06.22.
//

import Foundation

enum Item: Hashable {
    
    case item(UUID)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .item(let id):
            hasher.combine(id)
        }
    }
    
}
