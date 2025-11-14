//
//  BookmarkListView.swift
//  MoonReader
//
//  Bookmark List View - hiển thị danh sách bookmarks
//  Tương đương PrefEditBookmark.java trong Android
//

import SwiftUI

struct BookmarkListView: View {
    let book: Book
    @EnvironmentObject var bookDatabase: BookDatabase
    @State private var bookmarks: [Bookmark] = []
    @State private var selectedBookmark: Bookmark?
    @State private var showingEditBookmark = false
    
    var body: some View {
        NavigationView {
            List {
                if bookmarks.isEmpty {
                    EmptyBookmarksView()
                } else {
                    ForEach(bookmarks) { bookmark in
                        BookmarkRow(bookmark: bookmark)
                            .onTapGesture {
                                selectedBookmark = bookmark
                                // Navigate to bookmark position
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    deleteBookmark(bookmark)
                                } label: {
                                    Label("Xóa", systemImage: "trash")
                                }
                                
                                Button {
                                    selectedBookmark = bookmark
                                    showingEditBookmark = true
                                } label: {
                                    Label("Sửa", systemImage: "pencil")
                                }
                            }
                    }
                }
            }
            .navigationTitle("Đánh dấu trang")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") {
                        // Dismiss
                    }
                }
            }
            .onAppear {
                loadBookmarks()
            }
            .sheet(item: $selectedBookmark) { bookmark in
                EditBookmarkView(bookmark: bookmark)
            }
        }
    }
    
    private func loadBookmarks() {
        bookmarks = BookDatabase.shared.bookmarks.filter { $0.bookId == book.id }
    }
    
    private func deleteBookmark(_ bookmark: Bookmark) {
        BookDatabase.shared.deleteBookmark(bookmark)
        loadBookmarks()
    }
}

struct BookmarkRow: View {
    let bookmark: Bookmark
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Highlight color indicator
            HStack {
                Circle()
                    .fill(bookmark.highlightColor.color)
                    .frame(width: 12, height: 12)
                
                Text(formatDate(bookmark.time))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            // Original text
            if !bookmark.originalText.isEmpty {
                Text(bookmark.originalText)
                    .font(.body)
                    .lineLimit(3)
                    .padding(.leading, 20)
            }
            
            // Note
            if let note = bookmark.note, !note.isEmpty {
                Text(note)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
                    .padding(.leading, 20)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct EmptyBookmarksView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bookmark")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("Chưa có đánh dấu trang")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Chọn text và highlight để tạo đánh dấu trang")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct EditBookmarkView: View {
    let bookmark: Bookmark
    @Environment(\.dismiss) var dismiss
    @State private var note: String
    @State private var selectedColor: HighlightColor
    
    init(bookmark: Bookmark) {
        self.bookmark = bookmark
        _note = State(initialValue: bookmark.note ?? "")
        _selectedColor = State(initialValue: bookmark.highlightColor)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Văn bản đã chọn")) {
                    Text(bookmark.originalText)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Ghi chú")) {
                    TextEditor(text: $note)
                        .frame(height: 100)
                }
                
                Section(header: Text("Màu highlight")) {
                    HStack(spacing: 16) {
                        ForEach(HighlightColor.allCases, id: \.self) { color in
                            Button(action: {
                                selectedColor = color
                            }) {
                                Circle()
                                    .fill(color.color)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .stroke(selectedColor == color ? Color.blue : Color.gray, lineWidth: selectedColor == color ? 3 : 1)
                                    )
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sửa đánh dấu trang")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Hủy") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Lưu") {
                        saveBookmark()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveBookmark() {
        // Note: Bookmark is struct, need to create new one
        let newBookmark = Bookmark(
            id: bookmark.id,
            bookId: bookmark.bookId,
            bookFilename: bookmark.bookFilename,
            chapter: bookmark.chapter,
            position: bookmark.position,
            splitIndex: bookmark.splitIndex,
            highlightLength: bookmark.highlightLength,
            highlightColor: selectedColor,
            time: bookmark.time,
            note: note.isEmpty ? nil : note,
            originalText: bookmark.originalText,
            isUnderline: bookmark.isUnderline,
            isStrikethrough: bookmark.isStrikethrough
        )
        BookDatabase.shared.updateBookmark(newBookmark)
    }
}

