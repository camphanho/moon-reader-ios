//
//  BaseBookParser.swift
//  MoonReader
//
//  Base Book Parser - tương đương BaseEBook.java trong Android
//

import Foundation

protocol BookParser {
    func parse(fileURL: URL) throws -> ParsedBook
    func extractMetadata(fileURL: URL) throws -> BookMetadata
    func extractChapters(fileURL: URL) throws -> [Chapter]
}

struct ParsedBook {
    let metadata: BookMetadata
    let chapters: [Chapter]
    let coverImage: Data?
}

struct BookMetadata {
    let title: String
    let author: String
    let description: String?
    let publisher: String?
    let isbn: String?
    let publishDate: Date?
    let language: String?
    let coverImage: Data?
}

struct Chapter {
    let id: String
    let title: String
    let content: String
    let order: Int
    let filePath: String?
}

// Base implementation
class BaseBookParser: BookParser {
    func parse(fileURL: URL) throws -> ParsedBook {
        let metadata = try extractMetadata(fileURL: fileURL)
        let chapters = try extractChapters(fileURL: fileURL)
        
        return ParsedBook(
            metadata: metadata,
            chapters: chapters,
            coverImage: metadata.coverImage
        )
    }
    
    func extractMetadata(fileURL: URL) throws -> BookMetadata {
        // Base implementation - should be overridden
        throw BookParserError.notImplemented
    }
    
    func extractChapters(fileURL: URL) throws -> [Chapter] {
        // Base implementation - should be overridden
        throw BookParserError.notImplemented
    }
}

enum BookParserError: Error {
    case notImplemented
    case invalidFormat
    case fileNotFound
    case corruptedFile
    case unsupportedFormat
}

