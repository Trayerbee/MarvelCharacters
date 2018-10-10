//
//  Dictionary.swift
//  Transport
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {

    /// Represent dictionary as a HTTP parameter string:
    func parameterize(urlEscapeValue: Bool = false) -> String? {
        guard !self.isEmpty else { return nil }

        let pairs = map { key, rawValue -> String in
            let value: String
            if urlEscapeValue {
                value = String(describing: rawValue).urlEscaped
            } else {
                value = String(describing: rawValue)
            }
            return "\(key)=\(value)"
        }

        let joined = pairs.joined(separator: "&")
        return joined
    }
}
