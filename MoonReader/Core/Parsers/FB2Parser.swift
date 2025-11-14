//
//  FB2Parser.swift
//  MoonReader
//
//  FB2 Parser - tương đương Fb2.java trong Android
//

import Foundation

class FB2Parser: BaseBookParser {
    override func extractMetadata(fileURL: URL) throws -> BookMetadata {
        // FB2 is XML format
        // Parse description-title-info section
        
        guard let xmlData = try? Data(contentsOf: fileURL),
              let xmlString = String(data: xmlData, encoding: .utf8) else {
            throw BookParserError.corruptedFile
        }
        
        // Simple XML parsing - in production use XMLParser
        var title = "Unknown"
        var author = ""
        let description = ""
        
        // Extract title
        if let titleRange = xmlString.range(of: "<book-title[^>]*>([^<]+)</book-title>", options: .regularExpression) {
            title = String(xmlString[titleRange])
                .replacingOccurrences(of: "<book-title[^>]*>", with: "", options: .regularExpression)
                .replacingOccurrences(of: "</book-title>", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // Extract author
        if let authorRange = xmlString.range(of: "<first-name[^>]*>([^<]+)</first-name>", options: .regularExpression) {
            let firstName = String(xmlString[authorRange])
                .replacingOccurrences(of: "<first-name[^>]*>", with: "", options: .regularExpression)
                .replacingOccurrences(of: "</first-name>", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            var lastName = ""
            if let lastNameRange = xmlString.range(of: "<last-name[^>]*>([^<]+)</last-name>", options: .regularExpression) {
                lastName = String(xmlString[lastNameRange])
                    .replacingOccurrences(of: "<last-name[^>]*>", with: "", options: .regularExpression)
                    .replacingOccurrences(of: "</last-name>", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            author = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return BookMetadata(
            title: title,
            author: author,
            description: description.isEmpty ? nil : description,
            publisher: nil,
            isbn: nil,
            publishDate: nil,
            language: nil,
            coverImage: nil
        )
    }
    
    override func extractChapters(fileURL: URL) throws -> [Chapter] {
        // FB2 chapters are in <body> sections
        // Placeholder implementation
        return []
    }
}

