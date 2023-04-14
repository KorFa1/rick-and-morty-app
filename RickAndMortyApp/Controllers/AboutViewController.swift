//
//  AboutViewController.swift
//  RickAndMortyApp
//
//  Created by Кирилл Софрин on 10.04.2023.
//

import UIKit
import SnapKit

protocol AboutViewControllerDelegate: AnyObject {
    func updateData(indexPathAndImage: [Int: UIImage], addOrRemove: Bool)
}

final class AboutViewController: UIViewController {
    
    private var data: DataManager!
    
    weak var delegate: AboutViewControllerDelegate?
    
    private var isLiked: Bool!
    private var indexPath: Int!

    private let character: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 125
        image.layer.masksToBounds = true
        
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        
        return label
    }()
    
    private let speciesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        
        return label
    }()
    
    private let originLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to favorites", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        navigationItem.title = "About"
        
        self.delegate = data
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        addCharacterAndSetConstraints()
        addNameLabelAndSetConstraints()
        addStatusLabelAndSetConstraints()
        addSpeciesLabelAndSetConstraints()
        addOriginLabelAndSetConstraints()
        addlocationLabelAndSetConstraints()
        addLikeButtonAndSetConstraints()
    }
}

// MARK: - MainViewControllerDelegate
extension AboutViewController: MainViewControllerDelegate {
    
    func fetch(characterImage: UIImage, characherData: AboutCharacter) {
        character.image = characterImage
        nameLabel.text = "Name: \(characherData.name)"
        statusLabel.text = "Status: \(characherData.status)"
        speciesLabel.text = "Species: \(characherData.species)"
        originLabel.text = "Origin: \(characherData.origin)"
        locationLabel.text = "Location: \(characherData.location)"
    }
    
    func isImageLiked(toggle: Bool) {
        self.isLiked = toggle
        if toggle {
            likeButton.setTitle("Remove from favorites", for: .normal)
            likeButton.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        }
    }
    
    func fetch(indexPath: Int) {
        self.indexPath = indexPath
    }
}

// MARK: - MainViewControllerDataDelegate
extension AboutViewController: MainViewControllerDataDelegate {
    func fetch(referenceToData: DataManager) {
        self.data = referenceToData
    }
}

// MARK: - Helpers Methods
extension AboutViewController {
    
    private func addCharacterAndSetConstraints() {
        view.addSubview(character)
        character.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(250)
        }
    }

    private func addNameLabelAndSetConstraints() {
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(character.snp.bottom).offset(50)
        }
    }
    
    private func addStatusLabelAndSetConstraints() {
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
    }

    private func addSpeciesLabelAndSetConstraints() {
        view.addSubview(speciesLabel)
        speciesLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(statusLabel.snp.bottom).offset(10)
        }
    }

    private func addOriginLabelAndSetConstraints() {
        view.addSubview(originLabel)
        originLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(speciesLabel.snp.bottom).offset(10)
        }
    }
    
    private func addlocationLabelAndSetConstraints() {
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(originLabel.snp.bottom).offset(10)
        }
    }
    

    private func addLikeButtonAndSetConstraints() {
        view.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-35)
            make.width.equalToSuperview().dividedBy(1.7)
            make.height.equalTo(50)
        }
    }
}

// MARK: - Objc Methods
extension AboutViewController {
    
    @objc func likeButtonTapped() {
        if isLiked {
            isLiked = false
            delegate?.updateData(indexPathAndImage: [indexPath: character.image!], addOrRemove: isLiked)
            likeButton.setTitle("Add to favorites", for: .normal)
            likeButton.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        } else {
            isLiked = true
            delegate?.updateData(indexPathAndImage: [indexPath: character.image!], addOrRemove: isLiked)
            likeButton.setTitle("Remove from favorites", for: .normal)
            likeButton.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        }
    }
}

