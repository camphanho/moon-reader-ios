//
//  BookShelfView.swift
//  MoonReader
//
//  Book Shelf View - tương đương ActivityMain và BookShelfView trong Android
//

import SwiftUI

struct BookShelfView: View {
    @EnvironmentObject var bookDatabase: BookDatabase
    @State private var searchText = ""
    @State private var shelfStyle: ShelfStyle = .grid
    @State private var selectedBook: Book?
    @State private var showingBookDetail = false
    
    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return bookDatabase.books
        } else {
            return bookDatabase.books.filter { book in
                book.title.localizedCaseInsensitiveContains(searchText) ||
                book.author.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                // Books grid/list
                if filteredBooks.isEmpty {
                    EmptyShelfView()
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: shelfStyle == .grid ? gridColumns : [GridItem(.flexible())],
                            spacing: 16
                        ) {
                            ForEach(filteredBooks) { book in
                                BookCard(book: book)
                                    .onTapGesture {
                                        selectedBook = book
                                        showingBookDetail = true
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Thư viện sách")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { shelfStyle = .grid }) {
                            Label("Lưới", systemImage: "square.grid.2x2")
                        }
                        Button(action: { shelfStyle = .list }) {
                            Label("Danh sách", systemImage: "list.bullet")
                        }
                        Button(action: { shelfStyle = .coverFlow }) {
                            Label("Cover Flow", systemImage: "photo.on.rectangle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    ImportBookButton()
                }
            }
            .sheet(item: $selectedBook) { book in
                BookDetailView(book: book)
                    .environmentObject(bookDatabase)
            }
        }
    }
    
    private var gridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]
    }
}

enum ShelfStyle {
    case grid
    case list
    case coverFlow
}

struct BookCard: View {
    let book: Book
    @State private var coverImage: Image?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Cover image
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .aspectRatio(2/3, contentMode: .fit)
                
                if let coverImage = coverImage {
                    coverImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image(systemName: "book.closed")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                }
                
                // Progress indicator
                if book.progress > 0 {
                    VStack {
                        Spacer()
                        ProgressView(value: book.progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .padding(.horizontal, 4)
                            .padding(.bottom, 4)
                    }
                }
            }
            
            // Book info
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                if !book.author.isEmpty {
                    Text(book.author)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                // Rating
                if book.rating > 0 {
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(book.rating) ? "star.fill" : "star")
                                .font(.caption2)
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }
        }
        .onAppear {
            loadCoverImage()
        }
    }
    
    private func loadCoverImage() {
        // Load cover image from file path
        if let coverPath = book.coverImagePath,
           let data = try? Data(contentsOf: URL(fileURLWithPath: coverPath)),
           let uiImage = UIImage(data: data) {
            coverImage = Image(uiImage: uiImage)
        }
    }
}

struct EmptyShelfView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "books.vertical")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Chưa có sách")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("Nhấn nút + để thêm sách")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Tìm kiếm sách...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct BookDetailView: View {
    let book: Book
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var bookDatabase: BookDatabase
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Cover
                    HStack {
                        Spacer()
                        BookCard(book: book)
                            .frame(width: 150)
                        Spacer()
                    }
                    .padding(.top)
                    
                    // Title
                    Text(book.title)
                        .font(.title)
                        .bold()
                        .padding(.horizontal)
                    
                    // Author
                    if !book.author.isEmpty {
                        Text("Tác giả: \(book.author)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    
                    // Description
                    if !book.description.isEmpty {
                        Text(book.description)
                            .font(.body)
                            .padding(.horizontal)
                    }
                    
                    // Info
                    VStack(alignment: .leading, spacing: 8) {
                        InfoRow(label: "Định dạng", value: book.fileFormat.rawValue.uppercased())
                        InfoRow(label: "Kích thước", value: formatFileSize(book.fileSize))
                        InfoRow(label: "Tiến độ", value: "\(Int(book.progress * 100))%")
                    }
                    .padding(.horizontal)
                    
                    // Actions
                    VStack(spacing: 12) {
                        Button(action: {
                            // Open book
                            dismiss()
                        }) {
                            Text(book.currentPage > 0 ? "Tiếp tục đọc" : "Bắt đầu đọc")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // Toggle favorite
                        }) {
                            HStack {
                                Image(systemName: book.favorite ? "heart.fill" : "heart")
                                Text(book.favorite ? "Bỏ yêu thích" : "Yêu thích")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Chi tiết sách")
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
    
    private func formatFileSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useKB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
    }
}

import UIKit

