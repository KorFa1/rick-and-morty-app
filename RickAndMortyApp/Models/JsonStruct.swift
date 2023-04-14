//
//  JsonStruct.swift
//  RickAndMortyApp
//
//  Created by Кирилл Софрин on 10.04.2023.
//

import Foundation

// MARK: - RickAndMorty
struct RickAndMorty: Codable {
    let info: Info
    let results: [Result]
}

// MARK: - Info
struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - Result
struct Result: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Origin
struct Origin: Codable {
    let name: String
    let url: String
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let url: String
}
