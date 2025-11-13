//
//  MDParser.swift
//  MoonReader
//
//  Markdown Parser - tương đương Md.java trong Android
//

import Foundation

class MDParser: BaseBookParser {
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
        
        // Split by headers (# ## ###)
        let lines = content.components(separatedBy: .newlines)
        var chapters: [Chapter] = []
        var currentChapter: (title: String, content: [String])?
        
        for line in lines {
            if line.hasPrefix("# ") {
                // Save previous chapter
                if let chapter = currentChapter {
                    let chapterContent = chapter.content.joined(separator: "\n")
                    chapters.append(Chapter(
                        id: "chapter_\(chapters.count)",
                        title: chapter.title,
                        content: chapterContent,
                        order: chapters.count,
                        filePath: nil
                    ))
                }
                // Start new chapter
                let title = String(line.dropFirst(2)).trimmingCharacters(in: .whitespaces)
                currentChapter = (title: title, content: [])
            } else if let chapter = currentChapter {
                currentChapter?.content.append(line)
            }
        }
        
        // Add last chapter
        if let chapter = currentChapter {
            let chapterContent = chapter.content.joined(separator: "\n")
            chapters.append(Chapter(
                id: "chapter_\(chapters.count)",
                title: chapter.title,
                content: chapterContent,
                order: chapters.count,
                filePath: nil
            ))
        }
        
        // If no chapters found, create one with all content
        if chapters.isEmpty {
            chapters.append(Chapter(
                id: "chapter_0",
                title: "Nội dung",
                content: content,
                order: 0,
                filePath: nil
            ))
        }
        
        return chapters
    }
}

