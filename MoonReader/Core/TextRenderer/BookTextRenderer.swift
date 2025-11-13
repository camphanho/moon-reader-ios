//
//  BookTextRenderer.swift
//  MoonReader
//
//  Text Renderer - tương đương staticlayout package trong Android
//  Xử lý rendering text với HTML/CSS, hyphenation, custom layout
//

import SwiftUI
import UIKit

class BookTextRenderer {
    static func renderText(
        _ text: String,
        fontSize: CGFloat,
        lineSpacing: CGFloat,
        theme: ReaderTheme,
        margin: CGFloat,
        alignment: NSTextAlignment
    ) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 0
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: theme.textColor.uiColor,
            .paragraphStyle: paragraphStyle
        ]
        
        // Parse HTML if needed
        let processedText = parseHTML(text)
        
        return NSAttributedString(string: processedText, attributes: attributes)
    }
    
    private static func parseHTML(_ html: String) -> String {
        // Simple HTML parsing - remove tags
        // Full implementation sẽ sử dụng NSAttributedString HTML parsing
        var text = html
        
        // Remove HTML tags (simple regex)
        text = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        
        // Decode HTML entities
        text = text.replacingOccurrences(of: "&nbsp;", with: " ")
        text = text.replacingOccurrences(of: "&amp;", with: "&")
        text = text.replacingOccurrences(of: "&lt;", with: "<")
        text = text.replacingOccurrences(of: "&gt;", with: ">")
        text = text.replacingOccurrences(of: "&quot;", with: "\"")
        text = text.replacingOccurrences(of: "&#39;", with: "'")
        
        return text
    }
    
    static func applyHyphenation(_ text: String) -> String {
        // Hyphenation implementation
        // iOS có hỗ trợ hyphenation qua NSAttributedString
        return text
    }
}

extension ReaderTheme {
    var uiColor: UIColor {
        switch self {
        case .day: return .black
        case .night: return UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        case .amoled: return .white
        case .sepia: return UIColor(red: 0.3, green: 0.25, blue: 0.2, alpha: 1.0)
        }
    }
}

