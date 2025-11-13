//
//  PageCalculator.swift
//  MoonReader
//
//  Page Calculator - tính toán số trang và vị trí (Optimized)
//  Tương đương logic page calculation trong ActivityTxt.java
//

import Foundation
import UIKit

class PageCalculator {
    static func calculatePages(
        attributedText: NSAttributedString,
        containerSize: CGSize,
        margin: CGFloat
    ) -> [PageInfo] {
        var pages: [PageInfo] = []
        
        let textContainerSize = CGSize(
            width: containerSize.width - (margin * 2),
            height: containerSize.height - (margin * 2)
        )
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        var currentLocation = 0
        var pageIndex = 0
        
        while currentLocation < textStorage.length {
            let textContainer = NSTextContainer(size: textContainerSize)
            textContainer.lineFragmentPadding = 0
            layoutManager.addTextContainer(textContainer)
            
            let glyphRange = layoutManager.glyphRange(for: textContainer)
            
            if glyphRange.length == 0 {
                break
            }
            
            let characterRange = layoutManager.characterRange(
                forGlyphRange: glyphRange,
                actualGlyphRange: nil
            )
            
            let pageText = textStorage.attributedSubstring(from: characterRange)
            
            let pageInfo = PageInfo(
                pageIndex: pageIndex,
                characterRange: characterRange,
                text: pageText.string,
                attributedText: pageText
            )
            
            pages.append(pageInfo)
            
            currentLocation = characterRange.upperBound
            pageIndex += 1
            
            // Remove text container for next iteration
            if currentLocation < textStorage.length {
                layoutManager.removeTextContainer(at: layoutManager.textContainers.count - 1)
            }
        }
        
        return pages
    }
    
    static func findPage(
        for characterIndex: Int,
        in pages: [PageInfo]
    ) -> Int? {
        for (index, page) in pages.enumerated() {
            if characterIndex >= page.characterRange.location &&
               characterIndex < page.characterRange.upperBound {
                return index
            }
        }
        return nil
    }
    
    static func calculatePageCount(
        attributedText: NSAttributedString,
        containerSize: CGSize,
        margin: CGFloat
    ) -> Int {
        let pages = calculatePages(
            attributedText: attributedText,
            containerSize: containerSize,
            margin: margin
        )
        return pages.count
    }
}

struct PageInfo {
    let pageIndex: Int
    let characterRange: NSRange
    let text: String
    let attributedText: NSAttributedString
    
    var wordCount: Int {
        return text.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .count
    }
}
