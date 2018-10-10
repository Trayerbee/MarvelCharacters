//
//  MarvelCharactersTarget.swift
//  Transport
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import Foundation
import Shared
import Entity

public enum MarvelCharactersTarget {
    case fetch
}

extension MarvelCharactersTarget: MarvelTarget {
    public var urlSession: URLSession {
        return URLSession(configuration: URLSessionConfiguration.default)
    }

    public var path: String {
        switch self {
        case .fetch:
            return "/v1/public/characters"
        }
    }

    public var method: Core.Method {
        switch self {
        case .fetch:
            return .get
        }
    }

    public var bodyFormat: Core.BodyFormat {
        switch self {
        case .fetch:
            return .querystring
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .fetch:
            let params: [String: Any] = [
                "apikey": MarvelAPIKey,
                "hash": hash,
                "limit": 25,
                "orderBy": "-modified"
            ]

            return params
        }
    }
}
