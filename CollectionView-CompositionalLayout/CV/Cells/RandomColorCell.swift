//
//  RandomColorCell.swift
//  CollectionView-CompositionalLayout
//
//  Created by Jonas Schlabertz on 09.06.22.
//

import UIKit
import SnapKit

class RandomColorCell: UICollectionViewCell {
    
    static let reuseIdentifier = "RandomColorCell"
    
    let indexLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1
        )
        
        indexLabel.numberOfLines = 0
        
        contentView.addSubview(indexLabel)
        
        indexLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.top.greaterThanOrEqualToSuperview()
            make.trailing.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(with indexPath: IndexPath) {
        indexLabel.text = "(\(indexPath.section), \(indexPath.row))"
    }
    
}
