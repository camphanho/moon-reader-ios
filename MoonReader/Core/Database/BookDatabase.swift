//
//  BookDatabase.swift
//  MoonReader
//
//  Database manager - tương đương BookDb.java trong Android
//  Sử dụng Core Data hoặc SQLite trực tiếp
//

import Foundation
import SQLite3

class BookDatabase: ObservableObject {
    static let shared = BookDatabase()
    
    @Published var books: [Book] = []
    @Published var bookmarks: [Bookmark] = []
    @Published var notes: [Note] = []
    @Published var statistics: [ReadingStatistics] = []
    
    private var db: OpaquePointer?
    private let dbPath: String
    
    private init() {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        dbPath = documentsPath.appendingPathComponent("mrbooks.db").path
        
        if !fileManager.fileExists(atPath: dbPath) {
            createDatabase()
        } else {
            openDatabase()
        }
        
        loadBooks()
    }
    
    private func openDatabase() {
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            print("Không thể mở database: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    
    private func createDatabase() {
        openDatabase()
        
        // Tạo bảng books
        let createBooksTable = """
        CREATE TABLE IF NOT EXISTS books (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            id TEXT UNIQUE,
            book TEXT,
            filename TEXT,
            lowerFilename TEXT,
            author TEXT,
            description TEXT,
            category TEXT,
            thumbFile TEXT,
            coverFile TEXT,
            addTime INTEGER,
            favorite INTEGER,
            downloadUrl TEXT,
            rate REAL,
            lastChapter INTEGER,
            lastPosition REAL,
            totalPages INTEGER,
            currentPage INTEGER,
            fileSize INTEGER,
            fileFormat TEXT,
            bak1 TEXT,
            bak2 TEXT
        );
        """
        
        // Tạo bảng notes (bookmarks)
        let createNotesTable = """
        CREATE TABLE IF NOT EXISTS notes (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            id TEXT UNIQUE,
            bookId TEXT,
            book TEXT,
            filename TEXT,
            lowerFilename TEXT,
            lastChapter INTEGER,
            lastSplitIndex INTEGER,
            lastPosition REAL,
            highlightLength INTEGER,
            highlightColor INTEGER,
            time INTEGER,
            bookmark TEXT,
            note TEXT,
            original TEXT,
            underline INTEGER,
            strikethrough INTEGER,
            bak TEXT
        );
        """
        
        // Tạo bảng statistics
        let createStatisticsTable = """
        CREATE TABLE IF NOT EXISTS statistics (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            id TEXT UNIQUE,
            filename TEXT,
            usedTime REAL,
            readWords INTEGER,
            dates TEXT
        );
        """
        
        executeSQL(createBooksTable)
        executeSQL(createNotesTable)
        executeSQL(createStatisticsTable)
    }
    
    private func executeSQL(_ sql: String) {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Lỗi thực thi SQL: \(String(cString: sqlite3_errmsg(db)))")
            }
        }
        sqlite3_finalize(statement)
    }
    
    // MARK: - Books
    
    func addBook(_ book: Book) {
        let sql = """
        INSERT OR REPLACE INTO books (
            id, book, filename, lowerFilename, author, description, category,
            thumbFile, coverFile, addTime, favorite, downloadUrl, rate,
            lastChapter, lastPosition, totalPages, currentPage, fileSize, fileFormat, bak1, bak2
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, book.id.uuidString, -1, nil)
            sqlite3_bind_text(statement, 2, book.title, -1, nil)
            sqlite3_bind_text(statement, 3, book.filename, -1, nil)
            sqlite3_bind_text(statement, 4, book.filename.lowercased(), -1, nil)
            sqlite3_bind_text(statement, 5, book.author, -1, nil)
            sqlite3_bind_text(statement, 6, book.description, -1, nil)
            sqlite3_bind_text(statement, 7, book.category, -1, nil)
            sqlite3_bind_text(statement, 8, book.thumbnailPath ?? "", -1, nil)
            sqlite3_bind_text(statement, 9, book.coverImagePath ?? "", -1, nil)
            sqlite3_bind_int64(statement, 10, Int64(book.addTime.timeIntervalSince1970))
            sqlite3_bind_int(statement, 11, book.favorite ? 1 : 0)
            sqlite3_bind_text(statement, 12, book.downloadUrl ?? "", -1, nil)
            sqlite3_bind_double(statement, 13, book.rating)
            sqlite3_bind_int(statement, 14, Int32(book.lastChapter))
            sqlite3_bind_double(statement, 15, book.lastPosition)
            sqlite3_bind_int(statement, 16, Int32(book.totalPages))
            sqlite3_bind_int(statement, 17, Int32(book.currentPage))
            sqlite3_bind_int64(statement, 18, book.fileSize)
            sqlite3_bind_text(statement, 19, book.fileFormat.rawValue, -1, nil)
            sqlite3_bind_text(statement, 20, book.groupBooks.joined(separator: ","), -1, nil)
            sqlite3_bind_text(statement, 21, book.groupName ?? "", -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                loadBooks()
            }
        }
        sqlite3_finalize(statement)
    }
    
    func loadBooks() {
        books.removeAll()
        let sql = "SELECT * FROM books ORDER BY addTime DESC;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                if let book = parseBook(from: statement) {
                    books.append(book)
                }
            }
        }
        sqlite3_finalize(statement)
    }
    
    private func parseBook(from statement: OpaquePointer?) -> Book? {
        guard let statement = statement else { return nil }
        
        let idString = String(cString: sqlite3_column_text(statement, 1))
        guard let id = UUID(uuidString: idString) else { return nil }
        
        let title = String(cString: sqlite3_column_text(statement, 2))
        let filename = String(cString: sqlite3_column_text(statement, 3))
        let author = String(cString: sqlite3_column_text(statement, 5))
        let description = String(cString: sqlite3_column_text(statement, 6))
        let category = String(cString: sqlite3_column_text(statement, 7))
        let thumbFile = String(cString: sqlite3_column_text(statement, 8))
        let coverFile = String(cString: sqlite3_column_text(statement, 9))
        let addTime = Date(timeIntervalSince1970: TimeInterval(sqlite3_column_int64(statement, 10)))
        let favorite = sqlite3_column_int(statement, 11) == 1
        let downloadUrl = String(cString: sqlite3_column_text(statement, 12))
        let rate = sqlite3_column_double(statement, 13)
        let lastChapter = Int(sqlite3_column_int(statement, 14))
        let lastPosition = sqlite3_column_double(statement, 15)
        let totalPages = Int(sqlite3_column_int(statement, 16))
        let currentPage = Int(sqlite3_column_int(statement, 17))
        let fileSize = sqlite3_column_int64(statement, 18)
        let fileFormatString = String(cString: sqlite3_column_text(statement, 19))
        let fileFormat = BookFormat(rawValue: fileFormatString) ?? .unknown
        let groupBooksString = String(cString: sqlite3_column_text(statement, 20))
        let groupBooks = groupBooksString.isEmpty ? [] : groupBooksString.components(separatedBy: ",")
        let groupName = String(cString: sqlite3_column_text(statement, 21))
        
        return Book(
            id: id,
            title: title,
            filename: filename,
            author: author,
            description: description,
            category: category,
            coverImagePath: coverFile.isEmpty ? nil : coverFile,
            thumbnailPath: thumbFile.isEmpty ? nil : thumbFile,
            addTime: addTime,
            favorite: favorite,
            downloadUrl: downloadUrl.isEmpty ? nil : downloadUrl,
            rating: rate,
            groupName: groupName.isEmpty ? nil : groupName,
            groupBooks: groupBooks,
            lastChapter: lastChapter,
            lastPosition: lastPosition,
            totalPages: totalPages,
            currentPage: currentPage,
            fileSize: fileSize,
            fileFormat: fileFormat
        )
    }
    
    func deleteBook(_ book: Book) {
        let sql = "DELETE FROM books WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, book.id.uuidString, -1, nil)
            sqlite3_step(statement)
        }
        sqlite3_finalize(statement)
        loadBooks()
    }
    
    // MARK: - Bookmarks
    
    func addBookmark(_ bookmark: Bookmark) {
        let sql = """
        INSERT OR REPLACE INTO notes (
            id, bookId, book, filename, lowerFilename, lastChapter, lastSplitIndex,
            lastPosition, highlightLength, highlightColor, time, note, original, underline, strikethrough
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, bookmark.id.uuidString, -1, nil)
            sqlite3_bind_text(statement, 2, bookmark.bookId.uuidString, -1, nil)
            sqlite3_bind_text(statement, 3, bookmark.bookFilename, -1, nil)
            sqlite3_bind_text(statement, 4, bookmark.bookFilename.lowercased(), -1, nil)
            sqlite3_bind_int(statement, 5, Int32(bookmark.chapter))
            sqlite3_bind_int(statement, 6, Int32(bookmark.splitIndex))
            sqlite3_bind_double(statement, 7, bookmark.position)
            sqlite3_bind_int(statement, 8, Int32(bookmark.highlightLength))
            sqlite3_bind_int(statement, 9, Int32(bookmark.highlightColor.rawValue))
            sqlite3_bind_int64(statement, 10, Int64(bookmark.time.timeIntervalSince1970))
            sqlite3_bind_text(statement, 11, bookmark.note ?? "", -1, nil)
            sqlite3_bind_text(statement, 12, bookmark.originalText, -1, nil)
            sqlite3_bind_int(statement, 13, bookmark.isUnderline ? 1 : 0)
            sqlite3_bind_int(statement, 14, bookmark.isStrikethrough ? 1 : 0)
            
            sqlite3_step(statement)
        }
        sqlite3_finalize(statement)
        loadBookmarks()
    }
    
    func loadBookmarks() {
        bookmarks.removeAll()
        let sql = "SELECT * FROM notes ORDER BY time DESC;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                if let bookmark = parseBookmark(from: statement) {
                    bookmarks.append(bookmark)
                }
            }
        }
        sqlite3_finalize(statement)
    }
    
    private func parseBookmark(from statement: OpaquePointer?) -> Bookmark? {
        guard let statement = statement else { return nil }
        
        let idString = String(cString: sqlite3_column_text(statement, 1))
        guard let id = UUID(uuidString: idString) else { return nil }
        
        let bookIdString = String(cString: sqlite3_column_text(statement, 2))
        guard let bookId = UUID(uuidString: bookIdString) else { return nil }
        
        let bookFilename = String(cString: sqlite3_column_text(statement, 4))
        let chapter = Int(sqlite3_column_int(statement, 5))
        let splitIndex = Int(sqlite3_column_int(statement, 6))
        let position = sqlite3_column_double(statement, 7)
        let highlightLength = Int(sqlite3_column_int(statement, 8))
        let highlightColorRaw = Int(sqlite3_column_int(statement, 9))
        let highlightColor = HighlightColor(rawValue: highlightColorRaw) ?? .yellow
        let time = Date(timeIntervalSince1970: TimeInterval(sqlite3_column_int64(statement, 10)))
        let note = String(cString: sqlite3_column_text(statement, 11))
        let originalText = String(cString: sqlite3_column_text(statement, 12))
        let isUnderline = sqlite3_column_int(statement, 13) == 1
        let isStrikethrough = sqlite3_column_int(statement, 14) == 1
        
        return Bookmark(
            id: id,
            bookId: bookId,
            bookFilename: bookFilename,
            chapter: chapter,
            position: position,
            splitIndex: splitIndex,
            highlightLength: highlightLength,
            highlightColor: highlightColor,
            time: time,
            note: note.isEmpty ? nil : note,
            originalText: originalText,
            isUnderline: isUnderline,
            isStrikethrough: isStrikethrough
        )
    }
    
    func deleteBookmark(_ bookmark: Bookmark) {
        let sql = "DELETE FROM notes WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, bookmark.id.uuidString, -1, nil)
            sqlite3_step(statement)
        }
        sqlite3_finalize(statement)
        loadBookmarks()
    }
    
    func updateBookmark(_ bookmark: Bookmark) {
        addBookmark(bookmark) // INSERT OR REPLACE sẽ update nếu đã tồn tại
    }
    
    // MARK: - Statistics
    
    func addStatistics(_ statistics: ReadingStatistics) {
        let sql = """
        INSERT OR REPLACE INTO statistics (
            id, filename, usedTime, readWords, dates
        ) VALUES (?, ?, ?, ?, ?);
        """
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, statistics.id.uuidString, -1, nil)
            sqlite3_bind_text(statement, 2, statistics.bookFilename, -1, nil)
            sqlite3_bind_double(statement, 3, statistics.usedTime)
            sqlite3_bind_int(statement, 4, Int32(statistics.readWords))
            
            // Serialize dates
            let datesString = statistics.dates.map { String($0.timeIntervalSince1970) }.joined(separator: ",")
            sqlite3_bind_text(statement, 5, datesString, -1, nil)
            
            sqlite3_step(statement)
        }
        sqlite3_finalize(statement)
        loadStatistics()
    }
    
    func loadStatistics() {
        statistics.removeAll()
        let sql = "SELECT * FROM statistics ORDER BY dates DESC;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                if let stat = parseStatistics(from: statement) {
                    statistics.append(stat)
                }
            }
        }
        sqlite3_finalize(statement)
    }
    
    private func parseStatistics(from statement: OpaquePointer?) -> ReadingStatistics? {
        guard let statement = statement else { return nil }
        
        let idString = String(cString: sqlite3_column_text(statement, 1))
        guard let id = UUID(uuidString: idString) else { return nil }
        
        let filename = String(cString: sqlite3_column_text(statement, 2))
        let usedTime = sqlite3_column_double(statement, 3)
        let readWords = Int(sqlite3_column_int(statement, 4))
        let datesString = String(cString: sqlite3_column_text(statement, 5))
        
        // Parse dates
        let dates = datesString.split(separator: ",").compactMap { timeString in
            if let timeInterval = TimeInterval(timeString) {
                return Date(timeIntervalSince1970: timeInterval)
            }
            return nil
        }
        
        return ReadingStatistics(
            id: id,
            bookFilename: filename,
            usedTime: usedTime,
            readWords: readWords,
            dates: dates
        )
    }
    
    deinit {
        sqlite3_close(db)
    }
}

