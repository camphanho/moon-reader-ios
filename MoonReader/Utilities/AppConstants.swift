//
//  AppConstants.swift
//  MoonReader
//
//  App Constants - constants cho app
//

import Foundation
import SwiftUI

struct AppConstants {
    // App Info
    static let appName = "Moon Reader"
    static let appVersion = "1.0.0"
    static let appBuild = "1"
    
    // File Formats
    static let supportedFormats = [
        "epub", "fb2", "mobi", "azw3", "pdf", "txt", "docx", "rtf", 
        "chm", "md", "cbz", "cbr", "djvu"
    ]
    
    // Reading Settings Defaults
    static let defaultFontSize: Int = 18
    static let minFontSize: Int = 12
    static let maxFontSize: Int = 32
    
    static let defaultLineSpacing: Int = 8
    static let minLineSpacing: Int = 0
    static let maxLineSpacing: Int = 20
    
    static let defaultMargin: CGFloat = 20
    static let minMargin: CGFloat = 10
    static let maxMargin: CGFloat = 50
    
    // Database
    static let databaseName = "mrbooks.sqlite"
    
    // Cache
    static let maxCacheSize: Int = 50 // MB
    static let maxCachedPages: Int = 10
    
    // iCloud
    static let iCloudContainerIdentifier = "iCloud.com.moonreader.documents"
    
    // Colors
    static let highlightColors: [HighlightColor] = [
        .yellow, .green, .blue, .pink, .purple, .orange
    ]
    
    // Themes
    static let availableThemes: [ReaderTheme] = [
        .day, .night, .amoled, .sepia
    ]
    
    // Fonts
    static let availableFonts = [
        "System",
        "Times New Roman",
        "Georgia",
        "Palatino",
        "Helvetica",
        "Arial",
        "Courier New",
        "Verdana"
    ]
}

