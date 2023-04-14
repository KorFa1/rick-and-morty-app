//
//  LikedImagesViewCell.swift
//  RickAndMortyApp
//
//  Created by Кирилл Софрин on 13.04.2023.
//

import UIKit
import SnapKit

final class LikedImagesViewCell: UICollectionViewCell {

    let characterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addCharacterImageAndMakeConstraints()
        addShadow()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers Methods
extension LikedImagesViewCell {
    
    private func addCharacterImageAndMakeConstraints() {
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
}
