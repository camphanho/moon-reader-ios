//
//  AutoScrollManager.swift
//  MoonReader
//
//  Auto Scroll Manager - tự động cuộn trang
//  Tương đương auto-scroll modes trong Android
//

import Foundation
import SwiftUI

enum AutoScrollMode {
    case off
    case byPixel
    case byLine
    case byPage
    case rollingBlind
}

class AutoScrollManager: ObservableObject {
    static let shared = AutoScrollManager()
    
    @Published var isScrolling = false
    @Published var scrollSpeed: Double = 1.0 // pixels per second
    @Published var mode: AutoScrollMode = .off
    
    private var scrollTimer: Timer?
    
    private init() {}
    
    func startScrolling(mode: AutoScrollMode, speed: Double) {
        stopScrolling()
        
        self.mode = mode
        self.scrollSpeed = speed
        self.isScrolling = true
        
        switch mode {
        case .off:
            break
        case .byPixel:
            startPixelScroll(speed: speed)
        case .byLine:
            startLineScroll(speed: speed)
        case .byPage:
            startPageScroll(speed: speed)
        case .rollingBlind:
            startRollingBlindScroll(speed: speed)
        }
    }
    
    func stopScrolling() {
        scrollTimer?.invalidate()
        scrollTimer = nil
        isScrolling = false
    }
    
    func pauseScrolling() {
        scrollTimer?.invalidate()
        scrollTimer = nil
    }
    
    func resumeScrolling() {
        if isScrolling {
            startScrolling(mode: mode, speed: scrollSpeed)
        }
    }
    
    private func startPixelScroll(speed: Double) {
        // Scroll by pixel
        scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            // Scroll logic sẽ được implement trong view
        }
    }
    
    private func startLineScroll(speed: Double) {
        // Scroll by line
        let interval = 60.0 / speed // lines per second
        scrollTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            // Scroll one line
        }
    }
    
    private func startPageScroll(speed: Double) {
        // Scroll by page
        let interval = 1.0 / speed // pages per second
        scrollTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            // Scroll one page
        }
    }
    
    private func startRollingBlindScroll(speed: Double) {
        // Rolling blind mode - scroll continuously
        scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            // Continuous scroll
        }
    }
}

