//
//  AboutCharacter.swift
//  RickAndMortyApp
//
//  Created by Кирилл Софрин on 12.04.2023.
//

import Foundation

final class AboutCharacter {
    
    let name: String
    let status: String
    let species: String
    let origin: String
    let location: String
    
    init(name: String, status: String, species: String, origin: String, location: String) {
        self.name = name
        self.status = status
        self.species = species
        self.origin = origin
        self.location = location
    }
}
