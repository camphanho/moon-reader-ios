//
//  Bookmark.swift
//  MoonReader
//
//  Bookmark model - tương đương NoteInfo trong Android BookDb
//

import Foundation

struct Bookmark: Identifiable, Codable {
    var id: UUID
    var bookId: UUID
    var bookFilename: String
    var chapter: Int
    var position: Double
    var splitIndex: Int
    var highlightLength: Int
    var highlightColor: HighlightColor
    var time: Date
    var note: String?
    var originalText: String
    var isUnderline: Bool
    var isStrikethrough: Bool
    
    init(
        id: UUID = UUID(),
        bookId: UUID,
        bookFilename: String,
        chapter: Int = 0,
        position: Double = 0.0,
        splitIndex: Int = 0,
        highlightLength: Int = 0,
        highlightColor: HighlightColor = .yellow,
        time: Date = Date(),
        note: String? = nil,
        originalText: String = "",
        isUnderline: Bool = false,
        isStrikethrough: Bool = false
    ) {
        self.id = id
        self.bookId = bookId
        self.bookFilename = bookFilename
        self.chapter = chapter
        self.position = position
        self.splitIndex = splitIndex
        self.highlightLength = highlightLength
        self.highlightColor = highlightColor
        self.time = time
        self.note = note
        self.originalText = originalText
        self.isUnderline = isUnderline
        self.isStrikethrough = isStrikethrough
    }
}

enum HighlightColor: Int, Codable, CaseIterable {
    case yellow = 0
    case green = 1
    case blue = 2
    case pink = 3
    case purple = 4
    case orange = 5
    
    var color: Color {
        switch self {
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .pink: return .pink
        case .purple: return .purple
        case .orange: return .orange
        }
    }
}

import SwiftUI

