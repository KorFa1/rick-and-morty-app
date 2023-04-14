//
//  Database.swift
//  RickAndMortyApp
//
//  Created by Кирилл Софрин on 13.04.2023.
//

import Foundation
import RealmSwift

final class LikedObject: Object {
    @Persisted var index: Int
    @Persisted var imageData: Data
    
    
    convenience init(index: Int, imageData: Data) {
        self.init()
        self.index = index
        self.imageData = imageData
    }
}
