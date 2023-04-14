//
//  ViewController.swift
//  RickAndMortyApp
//
//  Created by Кирилл Софрин on 10.04.2023.
//

import UIKit
import SnapKit

protocol MainViewControllerDelegate: AnyObject {
    func fetch(characterImage: UIImage, characherData: AboutCharacter)
    func isImageLiked(toggle: Bool)
    func fetch(indexPath: Int)
}

protocol MainViewControllerDataDelegate: AnyObject {
    func fetch(referenceToData: DataManager)
}

final class MainViewController: UIViewController {
    
    private let data = DataManager()
    
    weak var delegate: MainViewControllerDelegate?
    weak var dataDelegate: MainViewControllerDataDelegate?
    
    private let characterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .lightGray
        
        return collectionView
    }()
    
    private let upButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.alpha = 0.6
        button.setTitle("Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.isHidden = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "All Characters"
        
        characterCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        characterCollectionView.delegate = self
        characterCollectionView.dataSource = self
        
        data.delegate = self
        
        let bookmarksButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(bookmarksButtonTapped))
        navigationItem.rightBarButtonItem = bookmarksButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        characterCollectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        addCharacterCollectionViewAndSetConstraints()
        addUpButtonAndSetConstraints()
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let aboutViewController = AboutViewController()
        self.delegate = aboutViewController
        self.dataDelegate = aboutViewController
        
        delegate?.fetch(characterImage: data.characterImages[indexPath.item], characherData: data.aboutCharactersData[indexPath.item])
        delegate?.isImageLiked(toggle: data.likedImages.keys.contains(indexPath.item))
        delegate?.fetch(indexPath: indexPath.item)
        dataDelegate?.fetch(referenceToData: data)
        
        navigationController?.pushViewController(aboutViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.characterImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let image = data.characterImages[indexPath.row]
        cell.characterImage.image = image
        
        if !data.likedImages.keys.contains(indexPath.item) {
            cell.heartText.alpha = 0.0
        } else {
            cell.heartText.alpha = 0.7
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let width = collectionView.frame.width / 2 - 15
         let height = width
        
         return CGSize(width: width, height: height)
     }
}

// MARK: - UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height, data.isFetchingData == false {
            data.isFetchingData = true
            NetworkManager.shared.fetchData()
        }
        upButton.isHidden = offsetY <= 1000
    }
}

// MARK: - DataManagerDelegate
extension MainViewController: DataManagerDelegate {
    
    func didUpdateImages() {
        DispatchQueue.main.async { [weak self] in
            self?.characterCollectionView.reloadData()
        }
    }
}

// MARK: - Helpers Methods
extension MainViewController {
    
    private func addCharacterCollectionViewAndSetConstraints() {
        view.addSubview(characterCollectionView)
        characterCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addUpButtonAndSetConstraints() {
        view.addSubview(upButton)
        upButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        upButton.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
    }
}

// MARK: - Objc Methods
extension MainViewController {
    
    @objc func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.characterCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    @objc func bookmarksButtonTapped() {
        let likedImagesViewController = LikedImagesViewController()
        self.dataDelegate = likedImagesViewController
        dataDelegate?.fetch(referenceToData: data)
        navigationController?.pushViewController(likedImagesViewController, animated: true)
    }
}
