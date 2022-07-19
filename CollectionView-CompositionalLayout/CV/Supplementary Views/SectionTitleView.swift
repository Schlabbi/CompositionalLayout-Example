//
//  SectionTitleView.swift
//  CollectionView-CompositionalLayout
//
//  Created by Jonas Schlabertz on 11.07.22.
//

import UIKit

class SectionTitleView: UICollectionReusableView {
    
    static let reuseIdentifier = "SectionTitleView"
    
    let titleLabel: UILabel = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(with title: String) {
        titleLabel.text = title
    }
    
}
