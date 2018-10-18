//
//  MarvelCharactersInteractor.swift
//  Interactor
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import Foundation
import Transport
import Entity

public struct CharacterCellData{
    public let name: String
    public let imageURL: String
    fileprivate init(with character: MarvelCharacter) {
        self.name = character.name
        self.imageURL = character.thumbnail.fullPath
    }
}

public class MarvelCharactersInteractor {
    private var downloadedCharacters: [MarvelCharacter] = []

    var presenter: MarvelCharactesCollectionPresenterAPI?

    func loadCharactersData(completion: @escaping ([CharacterCellData]) -> ()) {
        MarvelCharactersResponse.getCharacters { [weak self]
            (characters: [MarvelCharacter]) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.downloadedCharacters = characters
            completion(characters.toCellData())
        }
    }
}

extension Array where Element == MarvelCharacter {
    fileprivate func toCellData() -> [CharacterCellData] {
        return self.map{ CharacterCellData(with: $0) }
    }
}
