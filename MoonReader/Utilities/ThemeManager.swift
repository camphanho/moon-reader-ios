//
//  ThemeManager.swift
//  MoonReader
//
//  Theme Manager - quản lý themes tương đương PrefTheme và theme XML files trong Android
//

import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: ReaderTheme = .day
    
    private init() {
        // Load saved theme from UserDefaults
        if let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme"),
           let theme = ReaderTheme(rawValue: savedTheme) {
            currentTheme = theme
        }
    }
    
    func setTheme(_ theme: ReaderTheme) {
        currentTheme = theme
        UserDefaults.standard.set(theme.rawValue, forKey: "selectedTheme")
    }
}

extension ReaderTheme: RawRepresentable {
    public var rawValue: String {
        switch self {
        case .day: return "day"
        case .night: return "night"
        case .amoled: return "amoled"
        case .sepia: return "sepia"
        }
    }
    
    public init?(rawValue: String) {
        switch rawValue {
        case "day": self = .day
        case "night": self = .night
        case "amoled": self = .amoled
        case "sepia": self = .sepia
        default: return nil
        }
    }
}

// Predefined themes matching Android app
struct AppTheme {
    let name: String
    let backgroundColor: Color
    let textColor: Color
    let accentColor: Color
    
    static let dayTheme = AppTheme(
        name: "Day Theme",
        backgroundColor: .white,
        textColor: .black,
        accentColor: .blue
    )
    
    static let nightTheme = AppTheme(
        name: "Night Theme",
        backgroundColor: Color(red: 0.1, green: 0.1, blue: 0.1),
        textColor: Color(red: 0.9, green: 0.9, blue: 0.9),
        accentColor: .blue
    )
    
    static let amoledTheme = AppTheme(
        name: "AMOLED",
        backgroundColor: .black,
        textColor: .white,
        accentColor: .green
    )
    
    static let sepiaTheme = AppTheme(
        name: "Sepia",
        backgroundColor: Color(red: 0.98, green: 0.95, blue: 0.9),
        textColor: Color(red: 0.3, green: 0.25, blue: 0.2),
        accentColor: .brown
    )
}

