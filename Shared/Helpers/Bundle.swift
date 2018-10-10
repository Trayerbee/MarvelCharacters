//
//  Bundle.swift
//  Shared
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import Foundation

extension Bundle {

    public var releaseVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }

    public var buildVersion: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }

    public var appName: String? {
        return infoDictionary?["CFBundleName"] as? String
    }

    /// Returns the current version of the app in the format:
    ///    `1.0-62-P` (version 1.0, build 62 in Production mode)
    ///    `1.1-95-D` (version 1.1, build 95 in Debug mode)
    public var fullVersion: String? {
        guard let release = releaseVersion, let build = buildVersion else {
            return nil
        }

        var type: String
        #if PRODUCTION
        type = "P"
        #else
        type = "D"
        #endif
        return "\(release)-\(build)-\(type)"
    }
}
