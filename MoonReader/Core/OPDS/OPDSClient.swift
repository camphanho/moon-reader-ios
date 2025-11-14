//
//  OPDSClient.swift
//  MoonReader
//
//  OPDS Client - kết nối thư viện trực tuyến
//  Tương đương opds package trong Android
//

import Foundation
import SwiftUI

struct OPDSFeed {
    let title: String
    let id: String
    let entries: [OPDSEntry]
    let links: [OPDSLink]
}

struct OPDSEntry {
    let id: String
    let title: String
    let authors: [String]
    let summary: String?
    let links: [OPDSLink]
    let coverImageURL: URL?
}

struct OPDSLink {
    let href: URL
    let rel: String
    let type: String?
}

class OPDSClient: ObservableObject {
    static let shared = OPDSClient()
    
    private let session = URLSession.shared
    
    func fetchFeed(from url: URL) async throws -> OPDSFeed {
        let (_, _) = try await session.data(from: url)
        
        // Parse OPDS XML/Atom feed
        // Implementation sẽ parse XML/Atom feed
        // Placeholder implementation
        return OPDSFeed(
            title: "OPDS Feed",
            id: UUID().uuidString,
            entries: [],
            links: []
        )
    }
    
    func searchCatalog(_ catalogURL: URL, query: String) async throws -> OPDSFeed {
        // Search in OPDS catalog
        let searchURL = catalogURL.appendingPathComponent("search")
            .appendingQueryItem(name: "q", value: query)
        
        return try await fetchFeed(from: searchURL)
    }
    
    func downloadBook(_ entry: OPDSEntry) async throws -> URL {
        // Find download link
        guard let downloadLink = entry.links.first(where: { link in
            link.type?.contains("epub") == true || link.type?.contains("pdf") == true
        }) else {
            throw OPDSError.noDownloadLink
        }
        
        // Download book
        let (data, _) = try await session.data(from: downloadLink.href)
        
        // Save to documents
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filename = "\(entry.title).epub"
        let fileURL = documentsURL.appendingPathComponent(filename)
        
        try data.write(to: fileURL)
        
        return fileURL
    }
}

enum OPDSError: LocalizedError {
    case invalidURL
    case noDownloadLink
    case downloadFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL không hợp lệ"
        case .noDownloadLink:
            return "Không tìm thấy link tải sách"
        case .downloadFailed:
            return "Tải sách thất bại"
        }
    }
}

extension URL {
    func appendingQueryItem(name: String, value: String) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        var queryItems = components?.queryItems ?? []
        queryItems.append(URLQueryItem(name: name, value: value))
        components?.queryItems = queryItems
        return components?.url ?? self
    }
}

