//
//  MarvelCharactesCollectionPresenter.swift
//  MarvelCharacters
//
//  Created by Karshigabekov, Ilyas on 11/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import UIKit
import Foundation

protocol MarvelCharactesCollectionPresenterAPI {
    func showCharacterWith(ID characterID: String)
}

class MarvelCharactesCollectionPresenter: NSObject, MarvelCharactesCollectionPresenterAPI {

    public override init() {
        interactor = MarvelCharactersInteractor()
    }

    func showCharacterWith(ID characterID: String) {

    }

    public var interactor: MarvelCharactersInteractor
    public var view: MarvelCharactersCollectionViewAPI?

    public func loadCharacters() {
        interactor.loadCharactersData(completion: {
            (cellData: [CharacterCellData]) in
            DispatchQueue.main.async { [unowned self]
                in
                self.view?.characters = cellData
            }
        })
    }
}
