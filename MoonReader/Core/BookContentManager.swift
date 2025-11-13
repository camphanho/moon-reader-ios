//
//  BookContentManager.swift
//  MoonReader
//
//  Book Content Manager - quản lý nội dung sách, chapters, pages
//  Tương đương logic load book content trong ActivityTxt.java
//

import Foundation

class BookContentManager {
    static let shared = BookContentManager()
    
    private var bookContents: [UUID: BookContent] = [:]
    
    private init() {}
    
    func loadBookContent(for book: Book) async throws -> BookContent {
        if let cached = bookContents[book.id] {
            return cached
        }
        
        // Load book file
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let booksFolder = documentsURL.appendingPathComponent("Books")
        let fileURL = booksFolder.appendingPathComponent(book.filename)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            throw BookContentError.fileNotFound
        }
        
        // Parse book
        let parser = BookParserFactory.createParser(for: book.fileFormat)
        let parsedBook = try parser.parse(fileURL: fileURL)
        
        // Create BookContent
        let content = BookContent(
            bookId: book.id,
            chapters: parsedBook.chapters,
            metadata: parsedBook.metadata
        )
        
        bookContents[book.id] = content
        
        return content
    }
    
    func getContent(for bookId: UUID) -> BookContent? {
        return bookContents[bookId]
    }
    
    func clearCache(for bookId: UUID) {
        bookContents.removeValue(forKey: bookId)
    }
    
    func clearAllCache() {
        bookContents.removeAll()
    }
}

struct BookContent {
    let bookId: UUID
    let chapters: [Chapter]
    let metadata: BookMetadata
    
    var totalChapters: Int {
        return chapters.count
    }
    
    func chapter(at index: Int) -> Chapter? {
        guard index >= 0 && index < chapters.count else { return nil }
        return chapters[index]
    }
}

enum BookContentError: LocalizedError {
    case fileNotFound
    case parseError
    case invalidFormat
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Không tìm thấy file sách"
        case .parseError:
            return "Lỗi parse sách"
        case .invalidFormat:
            return "Định dạng không hợp lệ"
        }
    }
}

