//
//  Core.swift
//  Transport
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import Foundation
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

    public enum Delivery<T> {
        case progress(percentage: Double)
        case received(request: URLRequest, response: HTTPURLResponse, payload: T)

        var payload: T? {
            switch self {
            case .progress:
                return nil

            case .received(_, _, let payload):
                return payload
            }
        }

        var completed: Bool {
            switch self {
            case .progress:
                return false

            case .received:
                return true
            }
        }

        var payloadAndResponse: (payload: T, response: HTTPURLResponse)? {
            switch self {
            case .progress:
                return nil

            case .received(_, let response, let payload):
                return (payload: payload, response: response)
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

        // Otherwise, here's some general cases:
        case general(message: String, code: Int, body: Data?) // A standard message (from system or VHI) based on network code, plus code, plus entire response data.

        public var code: Int? {
            switch self {
            case let .general(_, code, _): return code
            default: return nil
            }
        }
    }
}

extension Core.Error {

    /// Transform any error into a `Transport.Core.Error` so that it's standardized for public usage:
    /// All errors from the Network should pass through here before being returned publicly.
    internal static func standardize(error rawError: Swift.Error) -> Core.Error {

        func transform(error: Swift.Error) -> Core.Error? {
            if let coreError = error as? Core.Error {

                // no transformation needed:
                return coreError
            }
            else if let urlError = error as? URLError {
                switch urlError.code {

                case .notConnectedToInternet:
                    return Core.Error.noInternetConnection

                case .timedOut:
                    return Core.Error.timeout

                case .secureConnectionFailed:
                    return Core.Error.cantEstablishSecureConnection

                default:
                    break
                }
            }
            else if error is JSONError {
                return Core.Error.invalidResponse(debugInfo: String(describing: error))
            }
            else if let error = error as? String {
                return Core.Error.invalidResponse(debugInfo: error)
            }

            return nil
        }

        guard let standardCoreError = transform(error: rawError) else {
            return Core.Error.unknown
        }

        print(standardCoreError)
        return standardCoreError
    }

    /// Similar to above except can be used per-target when we need to mutate the error message, (for specific situations).
    /// Mostly we can just use standardize(error: Swift.Error)
    internal static func standardize<T: TargetType>(target: T, error: Swift.Error) -> Core.Error {

        let standardized = Core.Error.standardize(error: error)
        // The target gets a final chance to customize the error message if it wishes, before it's returned publicly:
        return target.customizeError(error: standardized)
    }

    /// Some default client-approved error messages:
    internal static func defaultErrorMessage(forCode code: Int ) -> String {
        switch code {
//        case 400: return "Oops, something went wrong. We couldn’t understand your request."
//        case 401: return "Ah, we need user authentication for this. Please log out and log back in again."
//        case 403: return "It looks like you don't have access to this section."
//        case 404: return "The Vhi service is currently unavailable. Sorry for the inconvenience, please try again later."
//        case 405: return "Sorry, something has gone wrong at our end. We’re working to get you back online as soon as possible."
//        case 408: return "It took too long to get a response from the server. Please try again in a few minutes."
//        case 503: return "Sorry, maintenance time, but it won't be too long. Please try again later."
//        case 409, 415, 422, 500:
//            return "Sorry, something has gone wrong at our end. We’re working to get you back online as soon as possible."
        default:
            return "The network returned an error: \(HTTPURLResponse.localizedString(forStatusCode: code).capitalized)"
        }
    }
}

extension Core.Error: CustomDebugStringConvertible {

    public var debugDescription: String {

        switch self {
        case let .general(_, code, body):
            let systemMessage = HTTPURLResponse.localizedString(forStatusCode: code).capitalized
            let message = "🥀 Network #\(code) error: \(systemMessage)"

            #if DEBUG
            // If we're compiling for debug, allow a little more info out to the console:
            if let body = body, let content = String(data: body, encoding: .utf8) {
                return "\(message), body: \(content.trim)."
            }
            else {
                return "\(message)."
            }
            #else
            return "\(message)."
            #endif

        case .cantEstablishSecureConnection:
            return "🥀 Network could not establish a secure connection."

        case .noInternetConnection:
            return "🥀 No network connection available"

        case .timeout:
            return "🥀 Network timed out"

        case .invalidResponse(let debugInfo):
            if let debugInfo = debugInfo {
                return "🥀 Invalid network response: \(debugInfo)"
            }
            else {
                return "🥀 Invalid network response, but no more info available. Try logging with associated debugInfo to provide more context."
            }

        case .unknown:
            return "🥀 Unknown network error 🤷🏻‍♂️"
        }
    }
}

extension ObservableType where E == Core.Delivery<Data> {

    /// Allow through only the payload value:
    func filterPayload() -> Observable<Data> {
        return map { $0.payload }.filterNil()
    }
}

// provide our own Core.Error equatable implementation,
// because we never want to compare the .invalidResponse messages.
extension Core.Error: Equatable {}
public func == (lhs: Core.Error, rhs: Core.Error) -> Bool {
    switch (lhs, rhs) {
    case (.unknown, .unknown):
        return true
    case (.timeout, .timeout):
        return true
    case (.noInternetConnection, .noInternetConnection):
        return true
    case (.invalidResponse, .invalidResponse):
        return true
    case (.cantEstablishSecureConnection, .cantEstablishSecureConnection):
        return true
    case (.general(let lhs), .general(let rhs)):
        if lhs.message != rhs.message { return false }
        if lhs.code != rhs.code { return false }
        if lhs.body != rhs.body { return false }
        return true
    default: return false
    }
}

public enum JSONError: Error {

}
