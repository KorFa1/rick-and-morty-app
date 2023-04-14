//
//  DataManager.swift
//  RickAndMortyApp
//
//  Created by Кирилл Софрин on 10.04.2023.
//

import UIKit
import RealmSwift

protocol DataManagerDelegate: AnyObject {
    func didUpdateImages()
}

final class DataManager {
    
    weak var delegate: DataManagerDelegate?
    
    var isFetchingData = false
    
    let realm = try! Realm()
    
    lazy var characterImages: [UIImage] = [] {
        didSet {
            delegate?.didUpdateImages()
        }
    }
    
    lazy var aboutCharactersData: [AboutCharacter] = []
    
    var likedImages: [Int: UIImage] = [:]
    
    init() {
        NetworkManager.shared.fetchData()
        NetworkManager.shared.delegate = self
        
        let likedObjects = realm.objects(LikedObject.self)
        for likedObject in likedObjects {
            let index = likedObject.index
            let image = UIImage(data: likedObject.imageData)!
            likedImages[index] = image
        }
    }
}

// MARK: - NetworkManagerDelegate
extension DataManager: NetworkManagerDelegate {
    
    func didFetch(images: [UIImage]) {
        self.characterImages.append(contentsOf: images)
        self.isFetchingData = false
    }
    
    func didFetch(aboutCharacters: [AboutCharacter]) {
        self.aboutCharactersData.append(contentsOf: aboutCharacters)
    }
}

// MARK: - AboutViewControllerDelegate
extension DataManager: AboutViewControllerDelegate {
    
    func updateData(indexPathAndImage: [Int: UIImage], addOrRemove: Bool) {
        if addOrRemove {
            if !likedImages.keys.contains(indexPathAndImage.keys) {
                likedImages.merge(indexPathAndImage) { $1 }
                
                guard let index = indexPathAndImage.keys.first else { return }
                guard let image = indexPathAndImage.values.first else { return }
                guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
                
                let likedObject = LikedObject(index: index, imageData: imageData)
                
                try! realm.write { realm.add(likedObject) }
            }
        } else {
            if likedImages.keys.contains(indexPathAndImage.keys) {
                let keyToRemove = indexPathAndImage.keys.first
                likedImages.removeValue(forKey: keyToRemove!)
                
                guard let likedObject = realm.objects(LikedObject.self)
                    .filter("index == \(keyToRemove!)")
                    .first  else { return }
                
                try! realm.write { realm.delete(likedObject) }
            }
        }
    }
}
