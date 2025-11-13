//
//  Accessibility.swift
//  MoonReader
//
//  Accessibility - hỗ trợ accessibility cho app
//

import SwiftUI

extension View {
    func accessibilityLabel(_ label: String) -> some View {
        self.accessibility(label: Text(label))
    }
    
    func accessibilityHint(_ hint: String) -> some View {
        self.accessibility(hint: Text(hint))
    }
    
    func readingAccessibility() -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Reading content")
            .accessibilityAddTraits(.isStaticText)
    }
}

struct AccessibilitySettings {
    static var isVoiceOverEnabled: Bool {
        UIAccessibility.isVoiceOverRunning
    }
    
    static var isReduceMotionEnabled: Bool {
        UIAccessibility.isReduceMotionEnabled
    }
    
    static var preferredContentSizeCategory: UIContentSizeCategory {
        UIApplication.shared.preferredContentSizeCategory
    }
}

