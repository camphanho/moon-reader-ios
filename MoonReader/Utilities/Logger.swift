//
//  Logger.swift
//  MoonReader
//
//  Logger - logging utility cho debugging
//

import Foundation
import OSLog

class Logger {
    static let shared = Logger()
    
    private let logger = OSLog(subsystem: "com.moonreader", category: "App")
    
    private init() {}
    
    func debug(_ message: String) {
        os_log("%{public}@", log: logger, type: .debug, message)
    }
    
    func info(_ message: String) {
        os_log("%{public}@", log: logger, type: .info, message)
    }
    
    func error(_ message: String) {
        os_log("%{public}@", log: logger, type: .error, message)
    }
    
    func fault(_ message: String) {
        os_log("%{public}@", log: logger, type: .fault, message)
    }
}

