//
//  ReadingStatistics.swift
//  MoonReader
//
//  Reading statistics model - tương đương statistics table trong Android
//

import Foundation

struct ReadingStatistics: Identifiable, Codable {
    var id: UUID
    var bookFilename: String
    var usedTime: TimeInterval // seconds
    var readWords: Int
    var dates: [Date]
    
    init(
        id: UUID = UUID(),
        bookFilename: String,
        usedTime: TimeInterval = 0,
        readWords: Int = 0,
        dates: [Date] = []
    ) {
        self.id = id
        self.bookFilename = bookFilename
        self.usedTime = usedTime
        self.readWords = readWords
        self.dates = dates
    }
    
    var readHours: Double {
        return usedTime / 3600.0
    }
    
    var averageWordsPerMinute: Int {
        guard usedTime > 0 else { return 0 }
        return Int(Double(readWords) / (usedTime / 60.0))
    }
}

