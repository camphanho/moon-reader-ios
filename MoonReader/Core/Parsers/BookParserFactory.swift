//
//  BookParserFactory.swift
//  MoonReader
//
//  Factory để tạo parser phù hợp với format sách
//

import Foundation

class BookParserFactory {
    static func createParser(for format: BookFormat) -> BookParser {
        switch format {
        case .epub:
            return EPUBParser()
        case .fb2:
            return FB2Parser()
        case .mobi:
            return MOBIParser()
        case .pdf:
            return PDFParser()
        case .txt:
            return TXTParser()
        case .docx:
            return DOCXParser()
        case .rtf:
            return RTFParser()
        case .chm:
            return CHMParser()
        case .md:
            return MDParser()
        case .cbz, .cbr:
            return ComicParser()
        case .djvu:
            return DJVUParser()
        case .unknown:
            return TXTParser() // Fallback
        }
    }
    
    static func createParser(for fileURL: URL) -> BookParser {
        let format = BookFormat(from: fileURL.lastPathComponent)
        return createParser(for: format)
    }
}

