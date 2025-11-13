//
//  PerformanceOptimizer.swift
//  MoonReader
//
//  Performance Optimizer - cache và optimize rendering
//

import Foundation
import UIKit

class PerformanceOptimizer {
    static let shared = PerformanceOptimizer()
    
    private var pageCache: [String: [PageInfo]] = [:]
    private var imageCache: [String: UIImage] = [:]
    private let maxCacheSize = 50 // MB
    
    private init() {}
    
    func cachePages(_ pages: [PageInfo], for key: String) {
        // Limit cache size
        if pageCache.count > 10 {
            let oldestKey = pageCache.keys.first
            pageCache.removeValue(forKey: oldestKey ?? "")
        }
        
        pageCache[key] = pages
    }
    
    func getCachedPages(for key: String) -> [PageInfo]? {
        return pageCache[key]
    }
    
    func cacheImage(_ image: UIImage, for key: String) {
        // Check cache size
        let imageSize = estimateImageSize(image)
        let currentCacheSize = estimateTotalCacheSize()
        
        if currentCacheSize + imageSize > maxCacheSize * 1024 * 1024 {
            // Remove oldest images
            clearOldestImages()
        }
        
        imageCache[key] = image
    }
    
    func getCachedImage(for key: String) -> UIImage? {
        return imageCache[key]
    }
    
    func clearCache() {
        pageCache.removeAll()
        imageCache.removeAll()
    }
    
    private func estimateImageSize(_ image: UIImage) -> Int {
        guard let cgImage = image.cgImage else { return 0 }
        return cgImage.width * cgImage.height * 4 // RGBA
    }
    
    private func estimateTotalCacheSize() -> Int {
        return imageCache.values.reduce(0) { total, image in
            total + estimateImageSize(image)
        }
    }
    
    private func clearOldestImages() {
        // Remove half of the cache
        let keysToRemove = Array(imageCache.keys.prefix(imageCache.count / 2))
        for key in keysToRemove {
            imageCache.removeValue(forKey: key)
        }
    }
}

