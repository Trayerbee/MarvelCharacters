//
//  RawJSONDecodable.swift
//  Entity
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import Foundation

public struct RawJSONDecodable: Decodable {
    public let code: Int
    public let status: String
    public let copyright: String
    public let attributionText: String
    public let attributionHTML: String
    public let etag: String
    public let data: CharacterDataContainer
}

public struct CharacterDataContainer: Decodable {
    public let offset: Int
    public let limit: Int
    public let total: Int
    public let count: Int
    public let results: [MarvelCharacter]
}

public struct RawComics: Decodable {
    public let available: Int
    public let collectionURI: String
    public let items: [ComicBook]
    public let returned: Int
}
