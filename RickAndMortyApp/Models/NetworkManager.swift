//
//  NetworkManager.swift
//  RickAndMortyApp
//
//  Created by Кирилл Софрин on 10.04.2023.
//

import UIKit

protocol NetworkManagerDelegate: AnyObject {
    func didFetch(images: [UIImage])
    func didFetch(aboutCharacters: [AboutCharacter])
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    weak var delegate: NetworkManagerDelegate?
    
    private let numberOfPages = 42
    private var currentPage = 1
    
    private init() { }
    
    func fetchData() {
        guard currentPage <= numberOfPages else { return }
        
        let stringURL = "https://rickandmortyapi.com/api/character/?page=\(currentPage)"
        guard let url = URL(string: stringURL) else { return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            self.currentPage += 1
            
            if let rickAndMortyData = try? JSONDecoder().decode(RickAndMorty.self, from: data) {
                var images: [UIImage] = []
                rickAndMortyData.results.forEach { result in
                    let imageUrl = URL(string: result.image)
                    let imageData = try? Data(contentsOf: imageUrl!)
                    let image = UIImage(data: imageData!)
                    images.append(image!)
                }
                self.delegate?.didFetch(images: images)
                
                var aboutCharacters: [AboutCharacter] = []
                rickAndMortyData.results.forEach { result in
                    let name = result.name
                    let status = result.status
                    let species = result.species
                    let origin = result.origin.name
                    let location = result.location.name
                    let aboutCharacter = AboutCharacter(name: name, status: status, species: species, origin: origin, location: location)
                    aboutCharacters.append(aboutCharacter)
                }
                self.delegate?.didFetch(aboutCharacters: aboutCharacters)
            }
        }.resume()
    }
}
