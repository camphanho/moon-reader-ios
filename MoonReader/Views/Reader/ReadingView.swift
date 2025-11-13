//
//  ReadingView.swift
//  MoonReader
//
//  Reading View - tương đương ActivityTxt và MRBookView trong Android
//  Enhanced với haptic feedback và accessibility
//

import SwiftUI

struct ReadingView: View {
    @State private var currentBook: Book?
    @State private var showingSettings = false
    @State private var showingChapters = false
    @State private var isMenuVisible = true
    
    var body: some View {
        ZStack {
            if let book = currentBook {
                BookReaderView(book: book)
            } else {
                NoBookSelectedView()
            }
        }
        .sheet(isPresented: $showingSettings) {
            if let book = currentBook {
                // Settings for reading view - will be handled by BookReaderView
            }
        }
        .sheet(isPresented: $showingChapters) {
            ChaptersView(book: currentBook, viewModel: ReaderViewModel())
        }
    }
}

struct BookReaderView: View {
    let book: Book
    @StateObject private var viewModel = ReaderViewModel()
    @State private var showingMenu = false
    @State private var showingSettings = false
    @State private var showingChapters = false
    @State private var showingSearch = false
    @State private var showingBookmarks = false
    @State private var selectedText: String?
    @State private var selectedRange: NSRange?
    @State private var showingHighlightMenu = false
    @State private var showingTTS = false
    @StateObject private var textSelectionHandler = TextSelectionHandler()
    @EnvironmentObject var bookDatabase: BookDatabase
    
    var body: some View {
        ZStack {
            // Background color based on theme
            viewModel.readerSettings.theme.backgroundColor
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                LoadingView(message: "Đang tải sách...")
            } else if let error = viewModel.errorMessage {
                ErrorView(error: AppError.parseError(error)) {
                    Task {
                        await viewModel.loadBook(book)
                    }
                }
            } else if let page = viewModel.currentPage {
                // Check if PDF
                if book.fileFormat == .pdf {
                    PDFReaderView(book: book)
                } else {
                    // Display current page with enhanced text view
                    EnhancedTextView(
                        attributedText: page.attributedText,
                        theme: viewModel.readerSettings.theme,
                        margin: viewModel.readerSettings.margin,
                        onTextSelected: { text, range in
                            selectedText = text
                            selectedRange = range
                            HapticFeedback.generate(.selection)
                            showingHighlightMenu = true
                        }
                    )
                    .gesture(
                        DragGesture(minimumDistance: 50)
                            .onEnded { value in
                                handleSwipe(value)
                            }
                    )
                    .readingAccessibility()
                }
            } else {
                LoadingView(message: "Đang tải...")
            }
            
            // Top menu bar
            if showingMenu {
                VStack {
                    VStack(spacing: 0) {
                        ReaderTopBar(
                            book: book,
                            currentPage: viewModel.currentPageIndex,
                            totalPages: viewModel.totalPages,
                            onClose: { },
                            onSettings: { 
                                HapticFeedback.generate(.light)
                                showingMenu = false
                                showingSettings = true
                            },
                            onChapters: { 
                                HapticFeedback.generate(.light)
                                showingMenu = false
                                showingChapters = true
                            },
                            onSearch: {
                                HapticFeedback.generate(.light)
                                showingMenu = false
                                showingSearch = true
                            },
                            onBookmarks: {
                                HapticFeedback.generate(.light)
                                showingMenu = false
                                showingBookmarks = true
                            },
                            onTTS: {
                                HapticFeedback.generate(.light)
                                showingMenu = false
                                showingTTS = true
                            }
                        )
                        
                        // Chapter progress
                        if let content = viewModel.bookContent {
                            ChapterProgressView(
                                currentChapter: viewModel.currentChapterIndex,
                                totalChapters: content.totalChapters,
                                chapterTitle: content.chapter(at: viewModel.currentChapterIndex)?.title ?? ""
                            )
                        }
                    }
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            // Bottom menu bar
            if showingMenu {
                VStack {
                    Spacer()
                    VStack(spacing: 0) {
                        // Reading progress
                        ReadingProgressView(
                            currentPage: viewModel.currentPageIndex,
                            totalPages: viewModel.totalPages,
                            progress: viewModel.progress
                        )
                        
                        ReaderBottomBar(
                            onPrevious: { 
                                HapticFeedback.generate(.light)
                                viewModel.goToPreviousPage()
                            },
                            onNext: { 
                                HapticFeedback.generate(.light)
                                viewModel.goToNextPage()
                            },
                            onSettings: { 
                                HapticFeedback.generate(.light)
                                showingMenu = false
                                showingSettings = true
                            },
                            onChapters: { 
                                HapticFeedback.generate(.light)
                                showingMenu = false
                                showingChapters = true
                            }
                        )
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                showingMenu.toggle()
            }
            HapticFeedback.generate(.light)
        }
        .onAppear {
            Task {
                await viewModel.loadBook(book)
            }
        }
        .onDisappear {
            viewModel.stopReading()
        }
        .sheet(isPresented: $showingSettings) {
            ReaderSettingsView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingChapters) {
            ChaptersView(book: book, viewModel: viewModel)
        }
        .sheet(isPresented: $showingSearch) {
            SearchView(
                book: book,
                chapters: viewModel.bookContent?.chapters ?? [],
                isPresented: $showingSearch
            )
        }
        .sheet(isPresented: $showingBookmarks) {
            BookmarkListView(book: book)
        }
        .sheet(isPresented: $showingTTS) {
            if let page = viewModel.currentPage {
                TTSControlView(text: page.text)
            }
        }
        .sheet(isPresented: $showingHighlightMenu) {
            if let text = selectedText {
                HighlightMenuView(
                    selectedText: text,
                    onHighlight: { color in
                        if let range = selectedRange {
                            createHighlight(text: text, range: range, color: color)
                        }
                        HapticFeedback.generate(.success)
                        showingHighlightMenu = false
                    },
                    onNote: {
                        // Show note editor
                        showingHighlightMenu = false
                    },
                    onCopy: {
                        UIPasteboard.general.string = text
                        HapticFeedback.generate(.success)
                        showingHighlightMenu = false
                    },
                    onShare: {
                        // Show share sheet
                        showingHighlightMenu = false
                    },
                    onDictionary: {
                        // Dictionary handled in HighlightMenuView
                    }
                )
            }
        }
    }
    
    private func handleSwipe(_ value: DragGesture.Value) {
        if value.translation.width > 100 {
            viewModel.goToPreviousPage()
            HapticFeedback.generate(.medium)
        } else if value.translation.width < -100 {
            viewModel.goToNextPage()
            HapticFeedback.generate(.medium)
        }
    }
    
    private func createHighlight(text: String, range: NSRange, color: HighlightColor) {
        let bookmark = Bookmark(
            bookId: book.id,
            bookFilename: book.filename,
            chapter: viewModel.currentChapterIndex,
            position: Double(range.location),
            splitIndex: 0,
            highlightLength: range.length,
            highlightColor: color,
            time: Date(),
            note: nil,
            originalText: text,
            isUnderline: false,
            isStrikethrough: false
        )
        
        bookDatabase.addBookmark(bookmark)
    }
}

struct ReaderTopBar: View {
    let book: Book
    let currentPage: Int
    let totalPages: Int
    let onClose: () -> Void
    let onSettings: () -> Void
    let onChapters: () -> Void
    let onSearch: () -> Void
    let onBookmarks: () -> Void
    let onTTS: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onClose) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            .accessibilityLabel("Quay lại")
            
            Spacer()
            
            Text("\(currentPage + 1) / \(totalPages)")
                .font(.headline)
                .accessibilityLabel("Trang \(currentPage + 1) trong tổng số \(totalPages) trang")
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: onSearch) {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                }
                .accessibilityLabel("Tìm kiếm")
                
                Button(action: onBookmarks) {
                    Image(systemName: "bookmark")
                        .font(.title3)
                }
                .accessibilityLabel("Đánh dấu")
                
                Button(action: onChapters) {
                    Image(systemName: "list.bullet")
                        .font(.title3)
                }
                .accessibilityLabel("Mục lục")
                
                Button(action: onSettings) {
                    Image(systemName: "gearshape")
                        .font(.title3)
                }
                .accessibilityLabel("Cài đặt")
                
                Button(action: onTTS) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title3)
                }
                .accessibilityLabel("Đọc bằng giọng nói")
            }
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.9))
    }
}

struct ReaderBottomBar: View {
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onSettings: () -> Void
    let onChapters: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
                    .font(.title2)
            }
            .accessibilityLabel("Trang trước")
            
            Spacer()
            
            Button(action: onChapters) {
                Image(systemName: "list.bullet")
                    .font(.title3)
            }
            .accessibilityLabel("Mục lục")
            
            Spacer()
            
            Button(action: onSettings) {
                Image(systemName: "gearshape")
                    .font(.title3)
            }
            .accessibilityLabel("Cài đặt")
            
            Spacer()
            
            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .font(.title2)
            }
            .accessibilityLabel("Trang sau")
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.9))
    }
}

struct NoBookSelectedView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "book")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Chưa chọn sách")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("Vui lòng chọn sách từ thư viện để đọc")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Chưa chọn sách. Vui lòng chọn sách từ thư viện để đọc")
    }
}

struct ChaptersView: View {
    let book: Book?
    let viewModel: ReaderViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                if let content = viewModel.bookContent {
                    ForEach(Array(content.chapters.enumerated()), id: \.element.id) { index, chapter in
                        Button(action: {
                            viewModel.goToChapter(at: index)
                            HapticFeedback.generate(.selection)
                            dismiss()
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(chapter.title)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    if !chapter.content.isEmpty {
                                        Text(chapter.content.prefix(100) + "...")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .lineLimit(2)
                                    }
                                }
                                
                                Spacer()
                                
                                if index == viewModel.currentChapterIndex {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .accessibilityLabel("Chương \(index + 1): \(chapter.title)")
                    }
                } else {
                    Text("Chưa có mục lục")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Mục lục")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Reader Settings Model
struct ReaderSettings {
    var fontSize: Int = 18
    var fontName: String = "System"
    var lineSpacing: Int = 8
    var theme: ReaderTheme = .day
    var margin: CGFloat = 20
    var alignment: TextAlignment = .justified
    var pageTurnStyle: PageTurnStyle = .slide
}

enum ReaderTheme {
    case day
    case night
    case amoled
    case sepia
    
    var backgroundColor: Color {
        switch self {
        case .day: return .white
        case .night: return Color(red: 0.1, green: 0.1, blue: 0.1)
        case .amoled: return .black
        case .sepia: return Color(red: 0.98, green: 0.95, blue: 0.9)
        }
    }
    
    var textColor: Color {
        switch self {
        case .day: return .black
        case .night: return Color(red: 0.9, green: 0.9, blue: 0.9)
        case .amoled: return .white
        case .sepia: return Color(red: 0.3, green: 0.25, blue: 0.2)
        }
    }
}
