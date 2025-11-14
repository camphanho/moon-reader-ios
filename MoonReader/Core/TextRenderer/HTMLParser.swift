//
//  HTMLParser.swift
//  MoonReader
//
//  HTML Parser - convert HTML to NSAttributedString
//  Tương đương MyHtml.java trong Android
//

import Foundation
import UIKit

class HTMLParser {
    static func parse(_ html: String, baseURL: URL? = nil) -> NSAttributedString {
        // Use NSAttributedString HTML parsing
        guard let data = html.data(using: .utf8) else {
            return NSAttributedString(string: html)
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        // Note: baseURL is not directly supported in DocumentAttributeKey
        // We'll parse without baseURL and handle relative URLs separately if needed
        
        do {
            var documentAttributes: NSDictionary?
            let attributedString = try NSAttributedString(
                data: data,
                options: options,
                documentAttributes: &documentAttributes
            )
            return attributedString
        } catch {
            print("Lỗi parse HTML: \(error)")
            return NSAttributedString(string: cleanHTML(html))
        }
    }
    
    static func cleanHTML(_ html: String) -> String {
        var cleaned = html
        
        // Remove script and style tags
        cleaned = cleaned.replacingOccurrences(
            of: "<script[^>]*>.*?</script>",
            with: "",
            options: [.regularExpression, .caseInsensitive]
        )
        cleaned = cleaned.replacingOccurrences(
            of: "<style[^>]*>.*?</style>",
            with: "",
            options: [.regularExpression, .caseInsensitive]
        )
        
        // Convert HTML entities
        cleaned = cleaned.replacingOccurrences(of: "&nbsp;", with: " ")
        cleaned = cleaned.replacingOccurrences(of: "&amp;", with: "&")
        cleaned = cleaned.replacingOccurrences(of: "&lt;", with: "<")
        cleaned = cleaned.replacingOccurrences(of: "&gt;", with: ">")
        cleaned = cleaned.replacingOccurrences(of: "&quot;", with: "\"")
        cleaned = cleaned.replacingOccurrences(of: "&#39;", with: "'")
        cleaned = cleaned.replacingOccurrences(of: "&apos;", with: "'")
        cleaned = cleaned.replacingOccurrences(of: "&mdash;", with: "—")
        cleaned = cleaned.replacingOccurrences(of: "&ndash;", with: "–")
        cleaned = cleaned.replacingOccurrences(of: "&hellip;", with: "…")
        
        // Remove remaining HTML tags
        cleaned = cleaned.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )
        
        return cleaned
    }
    
    static func extractImages(from html: String, baseURL: URL?) -> [(url: URL, range: NSRange)] {
        var images: [(url: URL, range: NSRange)] = []
        
        let pattern = "<img[^>]*src=\"([^\"]+)\"[^>]*>"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsString = html as NSString
        let matches = regex?.matches(in: html, options: [], range: NSRange(location: 0, length: nsString.length))
        
        for match in matches ?? [] {
            if match.numberOfRanges >= 2 {
                let imageURLString = nsString.substring(with: match.range(at: 1))
                
                if let baseURL = baseURL,
                   let imageURL = URL(string: imageURLString, relativeTo: baseURL) {
                    images.append((url: imageURL, range: match.range))
                } else if let imageURL = URL(string: imageURLString) {
                    images.append((url: imageURL, range: match.range))
                }
            }
        }
        
        return images
    }
}

