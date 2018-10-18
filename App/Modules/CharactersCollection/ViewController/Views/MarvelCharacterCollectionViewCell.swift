//
//  MarvelCharacterCollectionViewCell.swift
//  Interface
//
//  Created by Karshigabekov, Ilyas on 11/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import UIKit
import Shared

class MarvelCharacterCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var thumbnailImageView: AsyncImageView!
    @IBOutlet private var nameLabel: UILabel!

    public func setCharacter(data cellData: CharacterCellData) {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
        nameLabel.text = cellData.name
        thumbnailImageView.setImage(with: cellData.imageURL)
    }
}
