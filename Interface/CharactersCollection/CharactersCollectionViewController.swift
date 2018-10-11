//
//  CharactersCollectionViewController.swift
//  Interface
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import UIKit
import Interactor


class CharactersCollectionViewController: UIViewController {
    @IBOutlet private var charactersCollection: UICollectionView!
    private var charactersData: [CharacterCellData] = []
}

//MARK: Lifecycle
extension CharactersCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        charactersCollection.dataSource = self
        charactersCollection.delegate = self
    }
}

extension CharactersCollectionViewController: CharactersCollectionViewAPI {
    var characters: [CharacterCellData] {
        set{
            charactersData = newValue
            self.charactersCollection.reloadData()
        }
        get{
            return charactersData
        }
    }
}

//MARK: Collection view delegate
extension CharactersCollectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Aspect ratio for cells is 26 : 33
        let width = (collectionView.bounds.size.width-8)/2
        let height = (26/33) * width
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

//MARK: Collection view datasource
extension CharactersCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as! MarvelCharacterCollectionViewCell
        cell.setCharacter(data: charactersData[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charactersData.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
