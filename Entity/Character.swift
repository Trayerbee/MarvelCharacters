//
//  Character.swift
//  Entity
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

// character details http://gateway.marvel.com/v1/public/characters/:id

import Foundation

public struct Character {
    public let id: String
    public let name: String
    public let description: String
    public let lastModified: Date
    public let thumbnailURL: URL
    public let fullSizedImageURL: URL
    public let featuredComicsIDList: [String]
}

public struct ComicBook {
    public let title: String
    public let id: String
    public let issueNumber: String
    public let description: String
    public let coverThumbnailURL: URL
    public let fullSizedCoverURL: URL
}
