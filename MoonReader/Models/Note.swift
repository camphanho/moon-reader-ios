//
//  Note.swift
//  MoonReader
//
//  Note/Annotation model
//

import Foundation

struct Note: Identifiable, Codable {
    var id: UUID
    var bookId: UUID
    var chapter: Int
    var position: Double
    var text: String
    var createdAt: Date
    var modifiedAt: Date
    
    init(
        id: UUID = UUID(),
        bookId: UUID,
        chapter: Int = 0,
        position: Double = 0.0,
        text: String,
        createdAt: Date = Date(),
        modifiedAt: Date = Date()
    ) {
        self.id = id
        self.bookId = bookId
        self.chapter = chapter
        self.position = position
        self.text = text
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
}

