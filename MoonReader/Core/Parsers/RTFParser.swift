//
//  RTFParser.swift
//  MoonReader
//
//  RTF Parser - tương đương Rtf.java trong Android
//

import Foundation

class RTFParser: BaseBookParser {
    override func extractMetadata(fileURL: URL) throws -> BookMetadata {
        let filename = fileURL.lastPathComponent
        let title = (filename as NSString).deletingPathExtension
        
        return BookMetadata(
            title: title,
            author: "",
            description: "",
            publisher: nil,
            isbn: nil,
            publishDate: nil,
            language: nil,
            coverImage: nil
        )
    }
    
    override func extractChapters(fileURL: URL) throws -> [Chapter] {
        // RTF parsing - can use NSAttributedString
        guard let rtfData = try? Data(contentsOf: fileURL),
              let attributedString = try? NSAttributedString(
                data: rtfData,
                options: [.documentType: NSAttributedString.DocumentType.rtf],
                documentAttributes: nil
              ) else {
            throw BookParserError.corruptedFile
        }
        
        let content = attributedString.string
        let chapter = Chapter(
            id: "chapter_0",
            title: "Nội dung",
            content: content,
            order: 0,
            filePath: nil
        )
        
        return [chapter]
    }
}

import UIKit

