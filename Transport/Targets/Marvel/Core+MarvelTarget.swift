//
//  Core+MarvelTarget.swift
//  Transport
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import Foundation
import Shared
import Entity

//http:///v1/public/characters?ts=1&apikey=&hash=&limit=25&orderBy=-modified
internal let MarvelAPIKey = "ff3d4847092294acc724123682af904b"
internal let hash = "412b0d63f1d175474216fadfcc4e4fed"

// Base protocol implementations:
protocol MarvelTarget: Target {}

extension MarvelTarget {

    public var hostname: String {
        return "gateway.marvel.com"
    }

    public var baseURL: URL {
        return URL(string: "https://\(hostname)")!
    }

    public var headers: [String: String]? {
        return [
            "Content-Type": bodyFormat.contentType,
        ]
    }

    public var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalCacheData // dataset too fluid at Comtech to allow caching in general.
    }
}

extension MarvelTarget {

    func fetchMarvelData(completion: @escaping (Data?, Error?) throws -> ()) throws {
        try fetchData { (data, response, error) in
            try completion(data, error)
        }
    }

    func fetchMarvelCharacters(completion: @escaping (RawJSONDecodable?) throws -> ()) throws {
        try fetchMarvelData { (data, error) in
            guard let data = data else {
                try completion(nil)
                return
            }
            let jsonDecoder = JSONDecoder()
            try completion(try jsonDecoder.decode(RawJSONDecodable.self, from: data))
        }
    }
}
