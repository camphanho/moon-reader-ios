//
//  iCloudSync.swift
//  MoonReader
//
//  iCloud Sync - đồng bộ với iCloud Drive
//  Tương đương cloud sync trong Android
//

import Foundation
import SwiftUI

class iCloudSync: ObservableObject {
    static let shared = iCloudSync()
    
    @Published var isSyncing = false
    @Published var syncProgress: Double = 0.0
    @Published var lastSyncDate: Date?
    
    private let containerIdentifier = "iCloud.com.moonreader.documents"
    
    private init() {
        checkiCloudAvailability()
    }
    
    func checkiCloudAvailability() -> Bool {
        if let _ = FileManager.default.ubiquityIdentityToken {
            return true
        }
        return false
    }
    
    func syncBooks() async throws {
        guard checkiCloudAvailability() else {
            throw CloudSyncError.iCloudNotAvailable
        }
        
        await MainActor.run {
            isSyncing = true
            syncProgress = 0.0
        }
        
        // Get iCloud container URL
        guard let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: containerIdentifier) else {
            throw CloudSyncError.iCloudNotAvailable
        }
        
        let documentsURL = iCloudURL.appendingPathComponent("Documents")
        
        // Create Documents folder if needed
        if !FileManager.default.fileExists(atPath: documentsURL.path) {
            try FileManager.default.createDirectory(at: documentsURL, withIntermediateDirectories: true)
        }
        
        // Sync books
        let books = BookDatabase.shared.books
        let totalBooks = books.count
        
        for (index, book) in books.enumerated() {
            // Copy book file to iCloud
            let localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(book.filename)
            
            if FileManager.default.fileExists(atPath: localURL.path) {
                let iCloudBookURL = documentsURL.appendingPathComponent(book.filename)
                
                // Check if file exists in iCloud
                if !FileManager.default.fileExists(atPath: iCloudBookURL.path) {
                    try FileManager.default.copyItem(at: localURL, to: iCloudBookURL)
                }
            }
            
            await MainActor.run {
                syncProgress = Double(index + 1) / Double(totalBooks)
            }
        }
        
        await MainActor.run {
            lastSyncDate = Date()
            isSyncing = false
        }
    }
    
    func downloadFromiCloud() async throws {
        guard checkiCloudAvailability() else {
            throw CloudSyncError.iCloudNotAvailable
        }
        
        await MainActor.run {
            isSyncing = true
            syncProgress = 0.0
        }
        
        guard let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: containerIdentifier) else {
            throw CloudSyncError.iCloudNotAvailable
        }
        
        let documentsURL = iCloudURL.appendingPathComponent("Documents")
        let localDocumentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // Get all files from iCloud
        let files = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        let totalFiles = files.count
        
        for (index, fileURL) in files.enumerated() {
            let filename = fileURL.lastPathComponent
            let localURL = localDocumentsURL.appendingPathComponent(filename)
            
            // Download if not exists locally
            if !FileManager.default.fileExists(atPath: localURL.path) {
                try FileManager.default.copyItem(at: fileURL, to: localURL)
                
                // Import book
                if let parser = BookParserFactory.parser(for: fileURL) {
                    let parsedBook = try parser.parse(fileURL: fileURL)
                    // Add to database
                    // Implementation sẽ thêm vào BookDatabase
                }
            }
            
            await MainActor.run {
                syncProgress = Double(index + 1) / Double(totalFiles)
            }
        }
        
        await MainActor.run {
            lastSyncDate = Date()
            isSyncing = false
        }
    }
}

enum CloudSyncError: LocalizedError {
    case iCloudNotAvailable
    case syncFailed
    case downloadFailed
    
    var errorDescription: String? {
        switch self {
        case .iCloudNotAvailable:
            return "iCloud không khả dụng. Vui lòng đăng nhập iCloud trong Settings."
        case .syncFailed:
            return "Đồng bộ thất bại. Vui lòng thử lại."
        case .downloadFailed:
            return "Tải xuống thất bại. Vui lòng thử lại."
        }
    }
}

