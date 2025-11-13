//
//  HapticFeedback.swift
//  MoonReader
//
//  Haptic Feedback - tactile feedback cho user interactions
//

import UIKit

enum HapticFeedbackType {
    case light
    case medium
    case heavy
    case success
    case warning
    case error
    case selection
}

class HapticFeedback {
    static func generate(_ type: HapticFeedbackType) {
        switch type {
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
    
    static func prepare() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
    }
}

