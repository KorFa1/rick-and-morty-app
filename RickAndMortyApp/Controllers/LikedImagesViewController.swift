//
//  LikedImagesViewController.swift
//  RickAndMortyApp
//
//  Created by Кирилл Софрин on 10.04.2023.
//

import UIKit

final class LikedImagesViewController: UIViewController {
    
    private var data: DataManager!
    
    private var imageArray: [UIImage] = []
    
    private let likedImagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .lightGray
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Favorites"
        
        likedImagesCollectionView.register(LikedImagesViewCell.self, forCellWithReuseIdentifier: "cell")
        
        imageArray = Array(data.likedImages.values)
        
        likedImagesCollectionView.delegate = self
        likedImagesCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        likedImagesCollectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        addLikedImagesCollectionViewAndSetConstraints()
    }
}

// MARK: - UICollectionViewDataSource
extension LikedImagesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.likedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LikedImagesViewCell
        let image = imageArray[indexPath.item]
        cell.characterImage.image = image
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LikedImagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let width = collectionView.frame.width / 2 - 15
         let height = width
        
         return CGSize(width: width, height: height)
     }
}

// MARK: - MainViewControllerDataDelegate
extension LikedImagesViewController: MainViewControllerDataDelegate {
    
    func fetch(referenceToData: DataManager) {
        self.data = referenceToData
    }
}

// MARK: - Helpers Methods
extension LikedImagesViewController {
    
    private func addLikedImagesCollectionViewAndSetConstraints() {
        view.addSubview(likedImagesCollectionView)
        likedImagesCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
