//
//  CharactersResponse.swift
//  Transport
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import Entity

public struct MarvelCharactersResponse {
    public static func getCharacters(completed: @escaping ([MarvelCharacter]) -> ()) {
        let target = MarvelCharactersTarget.fetch
        do {
            try target.fetchMarvelCharacters {
                (raw: RawJSONDecodable?) in
                guard let raw = raw else {
                    return
                }
                completed(raw.data.results)
            }
        } catch {
            print(error)
        }
    }
}
