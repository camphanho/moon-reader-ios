//
//  BookManager.swift
//  MoonReader
//
//  Book Manager - quản lý import, parse, lưu trữ sách
//  Tương đương logic import trong ActivityMain.java
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

class BookManager: ObservableObject {
    static let shared = BookManager()
    
    @Published var isImporting = false
    @Published var importProgress: Double = 0.0
    @Published var importError: String?
    
    let bookDatabase = BookDatabase.shared
    
    private init() {}
    
    // MARK: - Import Book
    
    func importBook(from fileURL: URL) async throws -> Book {
        isImporting = true
        importProgress = 0.0
        importError = nil
        
        defer {
            isImporting = false
            importProgress = 0.0
        }
        
        // Determine format
        let format = BookFormat(from: fileURL.lastPathComponent)
        guard format != .unknown else {
            throw BookImportError.unsupportedFormat
        }
        
        // Create parser
        let parser = BookParserFactory.createParser(for: format)
        importProgress = 0.2
        
        // Parse book
        let parsedBook = try parser.parse(fileURL: fileURL)
        importProgress = 0.5
        
        // Copy file to documents
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let booksFolder = documentsURL.appendingPathComponent("Books")
        
        if !FileManager.default.fileExists(atPath: booksFolder.path) {
            try FileManager.default.createDirectory(at: booksFolder, withIntermediateDirectories: true)
        }
        
        let destinationURL = booksFolder.appendingPathComponent(fileURL.lastPathComponent)
        
        // Remove existing file if any
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.removeItem(at: destinationURL)
        }
        
        try FileManager.default.copyItem(at: fileURL, to: destinationURL)
        importProgress = 0.7
        
        // Get file size
        let fileAttributes = try FileManager.default.attributesOfItem(atPath: destinationURL.path)
        let fileSize = fileAttributes[.size] as? Int64 ?? 0
        
        // Create Book model
        let book = Book(
            title: parsedBook.metadata.title,
            filename: destinationURL.lastPathComponent,
            author: parsedBook.metadata.author,
            description: parsedBook.metadata.description ?? "",
            category: "",
            coverImagePath: saveCoverImage(parsedBook.coverImage, for: destinationURL.lastPathComponent),
            thumbnailPath: nil,
            addTime: Date(),
            favorite: false,
            downloadUrl: nil,
            rating: 0.0,
            groupName: nil,
            groupBooks: [],
            lastChapter: 0,
            lastPosition: 0.0,
            totalPages: parsedBook.chapters.count,
            currentPage: 0,
            isbn: parsedBook.metadata.isbn,
            publisher: parsedBook.metadata.publisher,
            publishDate: parsedBook.metadata.publishDate,
            language: parsedBook.metadata.language,
            fileSize: fileSize,
            fileFormat: format
        )
        
        importProgress = 0.9
        
        // Save to database
        await MainActor.run {
            bookDatabase.addBook(book)
        }
        
        importProgress = 1.0
        
        return book
    }
    
    func importBooks(from fileURLs: [URL]) async throws -> [Book] {
        var importedBooks: [Book] = []
        
        for (index, url) in fileURLs.enumerated() {
            do {
                let book = try await importBook(from: url)
                importedBooks.append(book)
                importProgress = Double(index + 1) / Double(fileURLs.count)
            } catch {
                print("Lỗi import sách \(url.lastPathComponent): \(error)")
                // Continue with next book
            }
        }
        
        return importedBooks
    }
    
    // MARK: - Helper Methods
    
    private func saveCoverImage(_ imageData: Data?, for filename: String) -> String? {
        guard let imageData = imageData else { return nil }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let coversFolder = documentsURL.appendingPathComponent("Covers")
        
        if !FileManager.default.fileExists(atPath: coversFolder.path) {
            try? FileManager.default.createDirectory(at: coversFolder, withIntermediateDirectories: true)
        }
        
        let coverFilename = (filename as NSString).deletingPathExtension + ".jpg"
        let coverURL = coversFolder.appendingPathComponent(coverFilename)
        
        do {
            try imageData.write(to: coverURL)
            return coverURL.path
        } catch {
            print("Lỗi lưu cover image: \(error)")
            return nil
        }
    }
    
    func deleteBook(_ book: Book) {
        // Delete file
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let booksFolder = documentsURL.appendingPathComponent("Books")
        let fileURL = booksFolder.appendingPathComponent(book.filename)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.removeItem(at: fileURL)
        }
        
        // Delete cover
        if let coverPath = book.coverImagePath {
            try? FileManager.default.removeItem(atPath: coverPath)
        }
        
        // Delete from database
        bookDatabase.deleteBook(book)
    }
}

enum BookImportError: LocalizedError {
    case unsupportedFormat
    case fileNotFound
    case corruptedFile
    case parseError(String)
    
    var errorDescription: String? {
        switch self {
        case .unsupportedFormat:
            return "Định dạng sách không được hỗ trợ"
        case .fileNotFound:
            return "Không tìm thấy file"
        case .corruptedFile:
            return "File bị hỏng"
        case .parseError(let message):
            return "Lỗi parse: \(message)"
        }
    }
}

