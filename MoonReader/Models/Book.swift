//
//  Book.swift
//  MoonReader
//
//  Book model - tương đương BookDb.BookInfo trong Android
//

import Foundation
import SwiftUI

struct Book: Identifiable, Codable {
    var id: UUID
    var title: String
    var filename: String
    var author: String
    var description: String
    var category: String
    var coverImagePath: String?
    var thumbnailPath: String?
    var addTime: Date
    var favorite: Bool
    var downloadUrl: String?
    var rating: Double
    var groupName: String?
    var groupBooks: [String]
    
    // Reading progress
    var lastChapter: Int
    var lastPosition: Double
    var totalPages: Int
    var currentPage: Int
    
    // Metadata
    var isbn: String?
    var publisher: String?
    var publishDate: Date?
    var language: String?
    
    // File info
    var fileSize: Int64
    var fileFormat: BookFormat
    
    init(
        id: UUID = UUID(),
        title: String,
        filename: String,
        author: String = "",
        description: String = "",
        category: String = "",
        coverImagePath: String? = nil,
        thumbnailPath: String? = nil,
        addTime: Date = Date(),
        favorite: Bool = false,
        downloadUrl: String? = nil,
        rating: Double = 0.0,
        groupName: String? = nil,
        groupBooks: [String] = [],
        lastChapter: Int = 0,
        lastPosition: Double = 0.0,
        totalPages: Int = 0,
        currentPage: Int = 0,
        isbn: String? = nil,
        publisher: String? = nil,
        publishDate: Date? = nil,
        language: String? = nil,
        fileSize: Int64 = 0,
        fileFormat: BookFormat = .unknown
    ) {
        self.id = id
        self.title = title
        self.filename = filename
        self.author = author
        self.description = description
        self.category = category
        self.coverImagePath = coverImagePath
        self.thumbnailPath = thumbnailPath
        self.addTime = addTime
        self.favorite = favorite
        self.downloadUrl = downloadUrl
        self.rating = rating
        self.groupName = groupName
        self.groupBooks = groupBooks
        self.lastChapter = lastChapter
        self.lastPosition = lastPosition
        self.totalPages = totalPages
        self.currentPage = currentPage
        self.isbn = isbn
        self.publisher = publisher
        self.publishDate = publishDate
        self.language = language
        self.fileSize = fileSize
        self.fileFormat = fileFormat
    }
    
    var progress: Double {
        guard totalPages > 0 else { return 0.0 }
        return Double(currentPage) / Double(totalPages)
    }
    
    var isGroup: Bool {
        return !groupBooks.isEmpty
    }
}

enum BookFormat: String, Codable {
    case epub
    case fb2
    case mobi
    case pdf
    case txt
    case docx
    case rtf
    case chm
    case md
    case cbz
    case cbr
    case djvu
    case unknown
    
    init(from filename: String) {
        let ext = (filename as NSString).pathExtension.lowercased()
        switch ext {
        case "epub": self = .epub
        case "fb2", "fb2.zip": self = .fb2
        case "mobi", "azw", "azw3": self = .mobi
        case "pdf": self = .pdf
        case "txt": self = .txt
        case "docx": self = .docx
        case "rtf": self = .rtf
        case "chm": self = .chm
        case "md", "markdown": self = .md
        case "cbz": self = .cbz
        case "cbr": self = .cbr
        case "djvu": self = .djvu
        default: self = .unknown
        }
    }
}

