//
//  Core.swift
//  Transport
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import Foundation
import Shared
import Network

public enum Core {
}

extension Core {
    public enum Method {
        case get
        case post
        case put
        case patch

        var httpMethod: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .put: return "PUT"
            case .patch: return "PATCH"
            }
        }
    }

    public enum BodyFormat {
        case parametersAsJSON // simple: maps `self.parameters` on the target to JSON
        case jsonData // for more complex JSON structures, just uses the raw `body: Data` directly & specifies a JSON contentType.
        case querystring

        var contentType: String {
            switch self {
            case .parametersAsJSON: return "application/json; charset=utf-8"
            case .jsonData: return "application/json; charset=utf-8"
            case .querystring: return "application/x-www-form-urlencoded; charset=utf-8"
            }
        }
    }

    public enum Error: Swift.Error {
        // Certain specific conditions which we want to be sure to identify:
        case unknown
        case timeout
        case noInternetConnection
        /// i.e. couldn't parse the JSON received
        case invalidResponse(debugInfo: String?)
        case cantEstablishSecureConnection
        case malformedRequest

        // Otherwise, here's some general cases:
        case general(message: String, code: Int, body: Data?) // A standard message based on network code, plus code, plus entire response data.

        public var code: Int? {
            switch self {
            case let .general(_, code, _): return code
            default: return nil
            }
        }
    }
}

public enum JSONError: Error {

}
