//
//  Functions.swift
//  Shared
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import Foundation

public func isCurrentlyRunningUnitTests() -> Bool {
    return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
}

public func isCurrentlyRunningUITests() -> Bool {
    return ProcessInfo.processInfo.environment["UITestEnvironment"] != nil
}

public func isCurrentlyRunningTests() -> Bool {
    return isCurrentlyRunningUnitTests() || isCurrentlyRunningUITests()
}

public func secureTimeoutInterval() -> TimeInterval {
    if isCurrentlyRunningUITests() {
        return 5
    }
    return 5 * 60 // 5 minutes
}
