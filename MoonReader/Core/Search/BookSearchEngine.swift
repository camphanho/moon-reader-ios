//
//  BookSearchEngine.swift
//  MoonReader
//
//  Book Search Engine - tìm kiếm trong sách
//  Tương đương FuncSearch.java trong Android
//

import Foundation

class BookSearchEngine {
    static func search(
        query: String,
        in chapters: [Chapter],
        caseSensitive: Bool = false
    ) -> [SearchResult] {
        var results: [SearchResult] = []
        
        for chapter in chapters {
            let searchOptions: NSString.CompareOptions = caseSensitive ? [] : .caseInsensitive
            let content = chapter.content
            
            var searchRange = content.startIndex..<content.endIndex
            
            while let range = content.range(
                of: query,
                options: searchOptions,
                range: searchRange
            ) {
                let nsRange = NSRange(range, in: content)
                
                // Get context around match
                let contextStart = max(0, nsRange.location - 50)
                let contextEnd = min(content.count, nsRange.location + nsRange.length + 50)
                let contextRange = NSRange(location: contextStart, length: contextEnd - contextStart)
                
                if contextRange.location < content.count {
                    let context = (content as NSString).substring(with: contextRange)
                    
                    let result = SearchResult(
                        chapterId: chapter.id,
                        chapterTitle: chapter.title,
                        chapterIndex: chapter.order,
                        matchRange: nsRange,
                        matchText: (content as NSString).substring(with: nsRange),
                        context: context
                    )
                    
                    results.append(result)
                }
                
                // Move search range forward
                searchRange = range.upperBound..<content.endIndex
            }
        }
        
        return results
    }
    
    static func highlightMatches(
        in text: String,
        query: String,
        caseSensitive: Bool = false
    ) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let searchOptions: NSString.CompareOptions = caseSensitive ? [] : .caseInsensitive
        
        var searchRange = text.startIndex..<text.endIndex
        
        while let range = text.range(
            of: query,
            options: searchOptions,
            range: searchRange
        ) {
            let nsRange = NSRange(range, in: text)
            attributedString.addAttribute(
                .backgroundColor,
                value: UIColor.yellow,
                range: nsRange
            )
            
            searchRange = range.upperBound..<text.endIndex
        }
        
        return attributedString
    }
}

struct SearchResult {
    let chapterId: String
    let chapterTitle: String
    let chapterIndex: Int
    let matchRange: NSRange
    let matchText: String
    let context: String
}

