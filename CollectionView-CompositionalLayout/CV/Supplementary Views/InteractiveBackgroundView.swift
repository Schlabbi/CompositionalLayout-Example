//
//  InteractiveBackgroundView.swift
//  CollectionView-CompositionalLayout
//
//  Created by Jonas Schlabertz on 11.07.22.
//

import UIKit

class InteractiveBackgroundView: UICollectionReusableView {

    static let kind: String = "Background"
    static let reuseIdentifier: String = "InteractiveBackgroundView"
    
    let titleLabel: UILabel = .init()
    let subtitleLabel: UILabel = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBlue
        
        titleLabel.text = "I am an interactive background view"
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.greaterThanOrEqualToSuperview().inset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
        
        addSubview(subtitleLabel)
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.greaterThanOrEqualToSuperview().inset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload(with indexPath: IndexPath) {
        subtitleLabel.text = "Focused IndexPath: (\(indexPath.section), \( indexPath.row))"
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.layer.zPosition = -1
    }
    
}
