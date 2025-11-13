//
//  TXTParser.swift
//  MoonReader
//
//  TXT Parser - đơn giản nhất, đọc file text thuần
//

import Foundation

class TXTParser: BaseBookParser {
    override func extractMetadata(fileURL: URL) throws -> BookMetadata {
        let filename = fileURL.lastPathComponent
        let title = (filename as NSString).deletingPathExtension
        
        return BookMetadata(
            title: title,
            author: "",
            description: nil,
            publisher: nil,
            isbn: nil,
            publishDate: nil,
            language: nil,
            coverImage: nil
        )
    }
    
    override func extractChapters(fileURL: URL) throws -> [Chapter] {
        guard let content = try? String(contentsOf: fileURL, encoding: .utf8) else {
            throw BookParserError.corruptedFile
        }
        
        // Split into chapters (simple implementation - split by double newlines)
        let paragraphs = content.components(separatedBy: "\n\n")
        
        var chapters: [Chapter] = []
        for (index, paragraph) in paragraphs.enumerated() {
            let chapter = Chapter(
                id: "chapter_\(index)",
                title: "Chương \(index + 1)",
                content: paragraph,
                order: index,
                filePath: nil
            )
            chapters.append(chapter)
        }
        
        return chapters
    }
}

