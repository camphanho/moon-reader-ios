//
//  EPUBParser.swift
//  MoonReader
//
//  EPUB Parser - tương đương Epub.java trong Android
//  EPUB là ZIP archive chứa HTML files và metadata
//

import Foundation
// Note: Cần thêm thư viện ZIP như ZIPFoundation
// import ZIPFoundation

class EPUBParser: BaseBookParser {
    
    override func extractMetadata(fileURL: URL) throws -> BookMetadata {
        // EPUB is a ZIP archive
        // Structure:
        // - META-INF/container.xml (points to OPF file)
        // - OEBPS/ or similar folder with content
        // - *.opf file (metadata and manifest)
        
        guard let archive = ZipArchive(url: fileURL) else {
            throw BookParserError.corruptedFile
        }
        
        // Find container.xml
        guard let containerData = archive.data(forEntry: "META-INF/container.xml"),
              let containerXML = String(data: containerData, encoding: .utf8) else {
            throw BookParserError.corruptedFile
        }
        
        // Parse container.xml to find OPF file
        let opfPath = extractOPFPath(from: containerXML)
        guard let opfData = archive.data(forEntry: opfPath),
              let opfXML = String(data: opfData, encoding: .utf8) else {
            throw BookParserError.corruptedFile
        }
        
        // Parse OPF file for metadata
        return try parseOPFMetadata(opfXML: opfXML, archive: archive)
    }
    
    override func extractChapters(fileURL: URL) throws -> [Chapter] {
        guard let archive = ZipArchive(url: fileURL) else {
            throw BookParserError.corruptedFile
        }
        
        // Get container.xml
        guard let containerData = archive.data(forEntry: "META-INF/container.xml"),
              let containerXML = String(data: containerData, encoding: .utf8) else {
            throw BookParserError.corruptedFile
        }
        
        let opfPath = extractOPFPath(from: containerXML)
        guard let opfData = archive.data(forEntry: opfPath),
              let opfXML = String(data: opfData, encoding: .utf8) else {
            throw BookParserError.corruptedFile
        }
        
        // Parse OPF for manifest and spine
        return try parseOPFChapters(opfXML: opfXML, archive: archive, opfBasePath: opfPath)
    }
    
    // MARK: - Helper Methods
    
    private func extractOPFPath(from containerXML: String) -> String {
        // Simple XML parsing - find rootfile with media-type="application/oebps-package+xml"
        // In real implementation, use proper XML parser
        
        if let range = containerXML.range(of: "full-path=\"([^\"]+)\"", options: .regularExpression) {
            let match = String(containerXML[range])
            let path = match.replacingOccurrences(of: "full-path=\"", with: "")
                .replacingOccurrences(of: "\"", with: "")
            return path
        }
        
        // Fallback: common OPF locations
        if containerXML.contains("content.opf") {
            return "OEBPS/content.opf"
        }
        return "content.opf"
    }
    
    private func parseOPFMetadata(opfXML: String, archive: ZipArchive) throws -> BookMetadata {
        var title = "Unknown"
        var author = ""
        var description = ""
        var publisher: String?
        var isbn: String?
        var publishDate: Date?
        var language: String?
        var coverImage: Data?
        
        // Parse metadata section
        // Simple regex parsing - in production use XMLParser
        
        // Title
        if let titleRange = opfXML.range(of: "<dc:title[^>]*>([^<]+)</dc:title>", options: .regularExpression) {
            title = String(opfXML[titleRange])
                .replacingOccurrences(of: "<dc:title[^>]*>", with: "", options: .regularExpression)
                .replacingOccurrences(of: "</dc:title>", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // Author
        if let authorRange = opfXML.range(of: "<dc:creator[^>]*>([^<]+)</dc:creator>", options: .regularExpression) {
            author = String(opfXML[authorRange])
                .replacingOccurrences(of: "<dc:creator[^>]*>", with: "", options: .regularExpression)
                .replacingOccurrences(of: "</dc:creator>", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // Description
        if let descRange = opfXML.range(of: "<dc:description[^>]*>([^<]+)</dc:description>", options: .regularExpression) {
            description = String(opfXML[descRange])
                .replacingOccurrences(of: "<dc:description[^>]*>", with: "", options: .regularExpression)
                .replacingOccurrences(of: "</dc:description>", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // Publisher
        if let pubRange = opfXML.range(of: "<dc:publisher[^>]*>([^<]+)</dc:publisher>", options: .regularExpression) {
            publisher = String(opfXML[pubRange])
                .replacingOccurrences(of: "<dc:publisher[^>]*>", with: "", options: .regularExpression)
                .replacingOccurrences(of: "</dc:publisher>", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // ISBN
        if let isbnRange = opfXML.range(of: "<dc:identifier[^>]*id=\"isbn\"[^>]*>([^<]+)</dc:identifier>", options: .regularExpression) {
            isbn = String(opfXML[isbnRange])
                .replacingOccurrences(of: "<dc:identifier[^>]*id=\"isbn\"[^>]*>", with: "", options: .regularExpression)
                .replacingOccurrences(of: "</dc:identifier>", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // Language
        if let langRange = opfXML.range(of: "<dc:language[^>]*>([^<]+)</dc:language>", options: .regularExpression) {
            language = String(opfXML[langRange])
                .replacingOccurrences(of: "<dc:language[^>]*>", with: "", options: .regularExpression)
                .replacingOccurrences(of: "</dc:language>", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // Cover image - find in manifest with properties="cover-image"
        if let coverRange = opfXML.range(of: "properties=\"cover-image\"[^>]*href=\"([^\"]+)\"", options: .regularExpression) {
            let coverPath = String(opfXML[coverRange])
                .replacingOccurrences(of: "properties=\"cover-image\"[^>]*href=\"", with: "", options: .regularExpression)
                .replacingOccurrences(of: "\"", with: "")
            
            // Get base path of OPF
            let opfBasePath = (coverPath as NSString).deletingLastPathComponent
            let fullCoverPath = opfBasePath.isEmpty ? coverPath : "\(opfBasePath)/\(coverPath)"
            
            if let coverData = archive.data(forEntry: fullCoverPath) {
                coverImage = coverData
            }
        }
        
        return BookMetadata(
            title: title,
            author: author,
            description: description.isEmpty ? nil : description,
            publisher: publisher,
            isbn: isbn,
            publishDate: publishDate,
            language: language,
            coverImage: coverImage
        )
    }
    
    private func parseOPFChapters(opfXML: String, archive: ZipArchive, opfBasePath: String) throws -> [Chapter] {
        var chapters: [Chapter] = []
        
        // Parse manifest to get all HTML files
        var manifest: [String: String] = [:] // id -> href
        
        // Extract manifest items
        let manifestPattern = "<item[^>]*id=\"([^\"]+)\"[^>]*href=\"([^\"]+)\"[^>]*media-type=\"([^\"]+)\""
        let regex = try? NSRegularExpression(pattern: manifestPattern, options: [])
        let nsString = opfXML as NSString
        let results = regex?.matches(in: opfXML, options: [], range: NSRange(location: 0, length: nsString.length))
        
        for result in results ?? [] {
            if result.numberOfRanges >= 3 {
                let id = nsString.substring(with: result.range(at: 1))
                let href = nsString.substring(with: result.range(at: 2))
                let mediaType = nsString.substring(with: result.range(at: 3))
                
                if mediaType.contains("html") || mediaType.contains("xhtml") {
                    manifest[id] = href
                }
            }
        }
        
        // Parse spine to get reading order
        var spineItems: [String] = []
        let spinePattern = "<itemref[^>]*idref=\"([^\"]+)\""
        let spineRegex = try? NSRegularExpression(pattern: spinePattern, options: [])
        let spineResults = spineRegex?.matches(in: opfXML, options: [], range: NSRange(location: 0, length: nsString.length))
        
        for result in spineResults ?? [] {
            if result.numberOfRanges >= 1 {
                let idref = nsString.substring(with: result.range(at: 1))
                spineItems.append(idref)
            }
        }
        
        // Extract chapters in spine order
        let opfDir = (opfBasePath as NSString).deletingLastPathComponent
        
        for (index, spineId) in spineItems.enumerated() {
            guard let href = manifest[spineId] else { continue }
            
            // Resolve relative path
            let chapterPath = opfDir.isEmpty ? href : "\(opfDir)/\(href)"
            
            guard let chapterData = archive.data(forEntry: chapterPath),
                  let chapterHTML = String(data: chapterData, encoding: .utf8) else {
                continue
            }
            
            // Extract title from HTML
            let title = extractTitle(from: chapterHTML) ?? "Chương \(index + 1)"
            
            // Clean HTML content
            let content = cleanHTML(chapterHTML)
            
            let chapter = Chapter(
                id: spineId,
                title: title,
                content: content,
                order: index,
                filePath: chapterPath
            )
            
            chapters.append(chapter)
        }
        
        return chapters
    }
    
    private func extractTitle(from html: String) -> String? {
        // Extract title from <title> tag or first <h1>
        if let titleRange = html.range(of: "<title[^>]*>([^<]+)</title>", options: .regularExpression) {
            var title = String(html[titleRange])
            title = title.replacingOccurrences(of: "<title[^>]*>", with: "", options: .regularExpression)
            title = title.replacingOccurrences(of: "</title>", with: "")
            return title.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let h1Range = html.range(of: "<h1[^>]*>([^<]+)</h1>", options: .regularExpression) {
            var title = String(html[h1Range])
            title = title.replacingOccurrences(of: "<h1[^>]*>", with: "", options: .regularExpression)
            title = title.replacingOccurrences(of: "</h1>", with: "")
            return title.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return nil
    }
    
    private func cleanHTML(_ html: String) -> String {
        // Remove script and style tags
        var cleaned = html
        cleaned = cleaned.replacingOccurrences(of: "<script[^>]*>.*?</script>", with: "", options: [.regularExpression, .caseInsensitive])
        cleaned = cleaned.replacingOccurrences(of: "<style[^>]*>.*?</style>", with: "", options: [.regularExpression, .caseInsensitive])
        
        // Convert HTML entities
        cleaned = cleaned.replacingOccurrences(of: "&nbsp;", with: " ")
        cleaned = cleaned.replacingOccurrences(of: "&amp;", with: "&")
        cleaned = cleaned.replacingOccurrences(of: "&lt;", with: "<")
        cleaned = cleaned.replacingOccurrences(of: "&gt;", with: ">")
        cleaned = cleaned.replacingOccurrences(of: "&quot;", with: "\"")
        cleaned = cleaned.replacingOccurrences(of: "&#39;", with: "'")
        
        return cleaned
    }
}

// TODO: Implement với ZIPFoundation hoặc thư viện ZIP khác
// Placeholder ZipArchive class - cần thay thế bằng implementation thực
class ZipArchive {
    private let url: URL
    
    init?(url: URL) {
        self.url = url
        // TODO: Initialize với ZIPFoundation
        // guard let archive = Archive(url: url, accessMode: .read) else { return nil }
    }
    
    func data(forEntry path: String) -> Data? {
        // TODO: Extract file từ ZIP archive
        // Sử dụng ZIPFoundation:
        // guard let entry = archive[path] else { return nil }
        // return try? archive.extract(entry)
        return nil
    }
}

