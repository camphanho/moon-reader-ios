//
//  ReadingTracker.swift
//  MoonReader
//
//  Reading Tracker - theo dõi thống kê đọc
//  Tương đương statistics table trong Android BookDb
//

import Foundation

class ReadingTracker: ObservableObject {
    static let shared = ReadingTracker()
    
    @Published var currentSession: ReadingSession?
    @Published var todayStats: DailyStats?
    
    private var sessionStartTime: Date?
    private var lastUpdateTime: Date?
    private var wordsRead: Int = 0
    
    private init() {
        loadTodayStats()
    }
    
    func startSession(book: Book) {
        sessionStartTime = Date()
        lastUpdateTime = Date()
        wordsRead = 0
        
        currentSession = ReadingSession(
            bookId: book.id,
            bookFilename: book.filename,
            startTime: sessionStartTime!,
            wordsRead: 0
        )
    }
    
    func updateReadingProgress(words: Int, timeSpent: TimeInterval) {
        wordsRead += words
        lastUpdateTime = Date()
        
        if var session = currentSession {
            session.wordsRead = wordsRead
            session.duration = timeSpent
            currentSession = session
        }
        
        updateTodayStats(words: words, timeSpent: timeSpent)
    }
    
    func endSession() {
        guard let session = currentSession,
              let startTime = sessionStartTime else { return }
        
        let duration = Date().timeIntervalSince(startTime)
        
        // Save to database
        let statistics = ReadingStatistics(
            bookFilename: session.bookFilename,
            usedTime: duration,
            readWords: wordsRead,
            dates: [Date()]
        )
        
        BookDatabase.shared.addStatistics(statistics)
        
        // Reset
        currentSession = nil
        sessionStartTime = nil
        lastUpdateTime = nil
        wordsRead = 0
    }
    
    private func updateTodayStats(words: Int, timeSpent: TimeInterval) {
        let today = Calendar.current.startOfDay(for: Date())
        
        if todayStats?.date != today {
            todayStats = DailyStats(date: today, totalTime: 0, totalWords: 0)
        }
        
        todayStats?.totalTime += timeSpent
        todayStats?.totalWords += words
    }
    
    private func loadTodayStats() {
        let today = Calendar.current.startOfDay(for: Date())
        // Load from database
        // Implementation sẽ load từ BookDatabase
    }
}

struct ReadingSession {
    let bookId: UUID
    let bookFilename: String
    let startTime: Date
    var wordsRead: Int
    var duration: TimeInterval = 0
}

struct DailyStats {
    let date: Date
    var totalTime: TimeInterval
    var totalWords: Int
    
    var hoursRead: Double {
        return totalTime / 3600.0
    }
    
    var averageWordsPerMinute: Int {
        guard totalTime > 0 else { return 0 }
        return Int(Double(totalWords) / (totalTime / 60.0))
    }
}

