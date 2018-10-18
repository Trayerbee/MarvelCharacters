//
//  MarvelCharactersCollectionWireframe.swift
//  MarvelCharacters
//
//  Created by Karshigabekov, Ilyas on 11/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import UIKit
import Foundation

fileprivate let viewControllerIdentifier = "MarvelCharactersCollection"
fileprivate let storyboardIdentifier = "MarvelCharactersCollection"

class MarvelCharactersCollectionWireframe: NSObject, UIViewControllerTransitioningDelegate {
    private let presenter: MarvelCharactesCollectionPresenter
    let navigationViewController: UINavigationController

    override init() {

        guard let viewController =  UIStoryboard(name: storyboardIdentifier, bundle: Bundle.main).instantiateViewController(withIdentifier: viewControllerIdentifier) as? MarvelCharactersCollectionViewController else {
            fatalError("Failed to cast view controller")
        }
        navigationViewController = UINavigationController(rootViewController: viewController)
        presenter = MarvelCharactesCollectionPresenter()
        presenter.view = viewController
        super.init()
        viewController.transitioningDelegate = self
        presenter.loadCharacters()
    }

    convenience init(with window: UIWindow) {
        self.init()
        window.rootViewController = self.navigationViewController
        window.makeKeyAndVisible()
    }

}
