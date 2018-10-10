//
//  Character.swift
//  Entity
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

// character details http://gateway.marvel.com/v1/public/characters/:id

import Foundation

public struct MarvelCharacter: Decodable {
    public let id: String
    public let name: String
    public let description: String
    public let modified: String
    public let thumbnail: ImageURL
    public let comics: RawComics
    public let urls: [CharacterURL]
}

public struct ImageURL: Decodable {
    public let path: String
    public let fileExtension: String
    enum CodingKeys: String, CodingKey {
        case path = "path"
        case fileExtension = "extension"
    }
}

public struct ComicBook: Decodable {
    public let name: String
}

public struct CharacterURL: Decodable {
    let url: String
    let type: String
}
