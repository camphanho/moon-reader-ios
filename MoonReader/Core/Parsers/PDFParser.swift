//
//  PDFParser.swift
//  MoonReader
//
//  PDF Parser - tương đương PDFReader.java trong Android
//

import Foundation
import PDFKit

class PDFParser: BaseBookParser {
    override func extractMetadata(fileURL: URL) throws -> BookMetadata {
        guard let pdfDocument = PDFDocument(url: fileURL) else {
            throw BookParserError.corruptedFile
        }
        
        let title = pdfDocument.documentAttributes?[PDFDocumentAttribute.titleAttribute] as? String ?? "Unknown"
        let author = pdfDocument.documentAttributes?[PDFDocumentAttribute.authorAttribute] as? String ?? ""
        
        // Extract cover image (first page)
        var coverImage: Data?
        if let firstPage = pdfDocument.page(at: 0) {
            let pageRect = firstPage.bounds(for: .mediaBox)
            let renderer = UIGraphicsImageRenderer(size: pageRect.size)
            let image = renderer.image { ctx in
                ctx.cgContext.translateBy(x: 0, y: pageRect.size.height)
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                firstPage.draw(with: .mediaBox, to: ctx.cgContext)
            }
            coverImage = image.jpegData(compressionQuality: 0.8)
        }
        
        return BookMetadata(
            title: title,
            author: author,
            description: nil,
            publisher: nil,
            isbn: nil,
            publishDate: nil,
            language: nil,
            coverImage: coverImage
        )
    }
    
    override func extractChapters(fileURL: URL) throws -> [Chapter] {
        // PDF doesn't have traditional chapters
        // Each page is treated as a chapter
        guard let pdfDocument = PDFDocument(url: fileURL) else {
            throw BookParserError.corruptedFile
        }
        
        var chapters: [Chapter] = []
        let pageCount = pdfDocument.pageCount
        
        for index in 0..<pageCount {
            if let page = pdfDocument.page(at: index),
               let pageText = page.string {
                let chapter = Chapter(
                    id: "page_\(index)",
                    title: "Trang \(index + 1)",
                    content: pageText,
                    order: index,
                    filePath: nil
                )
                chapters.append(chapter)
            }
        }
        
        return chapters
    }
}

import UIKit

