//
//  ReaderViewModel.swift
//  MoonReader
//
//  Reader ViewModel - quản lý state của reading view
//

import Foundation
import SwiftUI

class ReaderViewModel: ObservableObject {
    @Published var currentBook: Book?
    @Published var bookContent: BookContent?
    @Published var currentChapterIndex: Int = 0
    @Published var currentPageIndex: Int = 0
    @Published var pages: [PageInfo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var readerSettings = ReaderSettings()
    
    private let contentManager = BookContentManager.shared
    
    func loadBook(_ book: Book) async {
        isLoading = true
        errorMessage = nil
        currentBook = book
        
        // Start reading session
        ReadingTracker.shared.startSession(book: book)
        
        do {
            let content = try await contentManager.loadBookContent(for: book)
            await MainActor.run {
                bookContent = content
                currentChapterIndex = book.lastChapter
                loadChapter(at: currentChapterIndex)
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func stopReading() {
        // End reading session
        if let page = currentPage {
            let words = page.wordCount
            let timeSpent = 1.0 // Calculate actual time
            ReadingTracker.shared.updateReadingProgress(words: words, timeSpent: timeSpent)
        }
        ReadingTracker.shared.endSession()
    }
    
    func loadChapter(at index: Int) {
        guard let content = bookContent,
              let chapter = content.chapter(at: index) else {
            return
        }
        
        currentChapterIndex = index
        
        // Check cache first
        let cacheKey = "\(book?.id.uuidString ?? "")_\(index)_\(readerSettings.fontSize)_\(readerSettings.margin)"
        if let cachedPages = PerformanceOptimizer.shared.getCachedPages(for: cacheKey) {
            pages = cachedPages
        } else {
            // Render chapter content
            let attributedText = renderChapter(chapter)
            
            // Calculate pages
            let containerSize = UIScreen.main.bounds.size
            pages = PageCalculator.calculatePages(
                attributedText: attributedText,
                containerSize: containerSize,
                margin: readerSettings.margin
            )
            
            // Cache pages
            PerformanceOptimizer.shared.cachePages(pages, for: cacheKey)
        }
        
        // Restore reading position if available
        if let book = currentBook, index == book.lastChapter {
            currentPageIndex = findPage(for: Int(book.lastPosition), in: pages) ?? 0
        } else {
            currentPageIndex = 0
        }
    }
    
    func goToNextPage() {
        if currentPageIndex < pages.count - 1 {
            currentPageIndex += 1
            saveReadingPosition()
        } else {
            // Move to next chapter
            goToNextChapter()
        }
    }
    
    func goToPreviousPage() {
        if currentPageIndex > 0 {
            currentPageIndex -= 1
            saveReadingPosition()
        } else {
            // Move to previous chapter
            goToPreviousChapter()
        }
    }
    
    func goToNextChapter() {
        guard let content = bookContent else { return }
        if currentChapterIndex < content.totalChapters - 1 {
            loadChapter(at: currentChapterIndex + 1)
        }
    }
    
    func goToPreviousChapter() {
        if currentChapterIndex > 0 {
            loadChapter(at: currentChapterIndex - 1)
        }
    }
    
    func goToChapter(at index: Int) {
        loadChapter(at: index)
    }
    
    func goToPage(at index: Int) {
        guard index >= 0 && index < pages.count else { return }
        currentPageIndex = index
        saveReadingPosition()
    }
    
    var currentPage: PageInfo? {
        guard currentPageIndex >= 0 && currentPageIndex < pages.count else { return nil }
        return pages[currentPageIndex]
    }
    
    var totalPages: Int {
        return pages.count
    }
    
    var progress: Double {
        guard totalPages > 0 else { return 0.0 }
        return Double(currentPageIndex + 1) / Double(totalPages)
    }
    
    // MARK: - Private Methods
    
    private func renderChapter(_ chapter: Chapter) -> NSAttributedString {
        // Parse HTML if needed
        let htmlContent = chapter.content
        
        // Check if content is HTML
        if htmlContent.contains("<") && htmlContent.contains(">") {
            let parsed = HTMLParser.parse(htmlContent)
            // Apply theme colors to parsed HTML
            return applyThemeToAttributedString(parsed)
        } else {
            // Plain text
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = CGFloat(readerSettings.lineSpacing)
            paragraphStyle.alignment = readerSettings.alignment.nsTextAlignment
            
            // Get font
            let font: UIFont
            if readerSettings.fontName == "System" {
                font = UIFont.systemFont(ofSize: CGFloat(readerSettings.fontSize))
            } else {
                font = UIFont(name: readerSettings.fontName, size: CGFloat(readerSettings.fontSize)) ?? UIFont.systemFont(ofSize: CGFloat(readerSettings.fontSize))
            }
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: readerSettings.theme.textColor.uiColor,
                .paragraphStyle: paragraphStyle
            ]
            
            return NSAttributedString(string: htmlContent, attributes: attributes)
        }
    }
    
    private func applyThemeToAttributedString(_ attributedString: NSAttributedString) -> NSAttributedString {
        let mutable = NSMutableAttributedString(attributedString: attributedString)
        let range = NSRange(location: 0, length: mutable.length)
        
        // Apply theme color to all text
        mutable.addAttribute(
            .foregroundColor,
            value: readerSettings.theme.textColor.uiColor,
            range: range
        )
        
        // Update font size if needed
        mutable.enumerateAttribute(.font, in: range) { value, range, _ in
            if let currentFont = value as? UIFont {
                let newFont: UIFont
                if readerSettings.fontName == "System" {
                    newFont = UIFont.systemFont(ofSize: CGFloat(readerSettings.fontSize))
                } else {
                    newFont = UIFont(name: readerSettings.fontName, size: CGFloat(readerSettings.fontSize)) ?? currentFont
                }
                mutable.addAttribute(.font, value: newFont, range: range)
            }
        }
        
        return mutable
    }
    
    private func findPage(for characterIndex: Int, in pages: [PageInfo]) -> Int? {
        return PageCalculator.findPage(for: characterIndex, in: pages)
    }
    
    private func saveReadingPosition() {
        guard let book = currentBook,
              let page = currentPage else { return }
        
        // Update book's reading position
        var updatedBook = book
        updatedBook.lastChapter = currentChapterIndex
        updatedBook.lastPosition = Double(page.characterRange.location)
        updatedBook.currentPage = currentPageIndex
        updatedBook.totalPages = totalPages
        
        // Save to database
        BookDatabase.shared.addBook(updatedBook)
    }
}

extension TextAlignment {
    var nsTextAlignment: NSTextAlignment {
        switch self {
        case .leading: return .left
        case .trailing: return .right
        case .center: return .center
        case .justified: return .justified
        }
    }
}

