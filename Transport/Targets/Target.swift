//
//  Target.swift
//  Transport
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import Foundation
import Shared

public protocol Target{
    var urlSession: URLSession { get }

    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: Core.Method { get }

    var headers: [String: String]? { get }

    var bodyFormat: Core.BodyFormat { get }

    /// The parameters to be encoded in the request.
    var parameters: [String: Any]? { get }

    /// overridable if you really want to (i.e. for BodyFormat.jsonData)
    var body: Data? { get }

    var cachePolicy: URLRequest.CachePolicy { get }

    var userAgent: String { get }

    func customizeError(error: Core.Error) -> Core.Error

    func customParameterization(parameters: [String: Any]?) -> String?
}

extension Target {
    public var userAgent: String {
        let appVersion = Bundle.main.fullVersion?.lowercased()
        return "\(appVersion ?? "")-marvel-test-assigment"
    }

    public func request() throws -> URLRequest {
        var request = URLRequest(url: try url())
        request.cachePolicy = isCurrentlyRunningUnitTests() ? .reloadIgnoringCacheData : self.cachePolicy
        request.httpMethod = method.httpMethod
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        return request
    }

    public func url() throws -> URL {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else { throw "Could not understand URL" }

        components.path = path

        switch method {
        case .get:
            guard let query = customParameterization(parameters: parameters) else { break }
            components.query = query

        default:
            break
        }

        guard let url = components.url else { throw "Could not form URL" }
        return url
    }

    public var body: Data? {
        switch method {

        case .get:
            return nil

        case .post, .put, .patch:
            guard let parameters = parameters else { return nil }

            switch bodyFormat {
            case .querystring:
                guard let joined: String = parameters.parameterize(urlEscapeValue: true) else { return nil }
                let postbody: Data? = joined.data(using: .utf8)
                return postbody

            case .parametersAsJSON:
                return try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

            case .jsonData:
                fatalError("Should override body directly to use .jsonData case")
            }
        }
    }
    /// Override point to customize the error message of a specific code:
    public func customizeError(error: Core.Error) -> Core.Error {
        // By default just return the error:
        return error
    }

    /// Override point in case we need any custom parameterization of our parameters.
    /// E.g. if the server expects odd serialization.
    public func customParameterization(parameters: [String: Any]?) -> String? {
        return parameters?.parameterize(urlEscapeValue: true)
    }
}

extension Target {
    func fetchData(completion:@escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let request = try? self.request() else {
            completion(nil, nil, Core.Error.malformedRequest)
            return
        }
        let dataTask = self.urlSession.dataTask(with: request) { completion($0, $1, $2) }
        dataTask.resume()
    }
}
