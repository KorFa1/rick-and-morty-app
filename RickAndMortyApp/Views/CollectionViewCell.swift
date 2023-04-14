//
//  CollectionViewCell.swift
//  RickAndMortyApp
//
//  Created by Кирилл Софрин on 10.04.2023.
//

import UIKit
import SnapKit

final class CollectionViewCell: UICollectionViewCell {
    
    let characterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let heartText: UILabel = {
        let label = UILabel()
        label.text = "❤️"
        label.font = UIFont.systemFont(ofSize: 40)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addCharacterImageAndSetConstraints()
        addShadow()
        addHeartTextAndSetConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
  
// MARK: - Helpers Methods
extension CollectionViewCell {
    
    private func addCharacterImageAndSetConstraints() {
        contentView.addSubview(characterImage)
        characterImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addShadow() {
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
    }
    
    private func addHeartTextAndSetConstraints() {
        contentView.addSubview(heartText)
        heartText.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
        }
    }
}
