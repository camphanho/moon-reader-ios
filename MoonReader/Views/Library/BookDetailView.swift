//
//  BookDetailView.swift
//  MoonReader
//
//  Book Detail View - chi tiết sách với actions
//  Enhanced version
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var bookDatabase: BookDatabase
    @State private var showingDeleteAlert = false
    
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
                    if let description = book.description, !description.isEmpty {
                        Text(description)
                            .font(.body)
                            .padding(.horizontal)
                    }
                    
                    // Info
                    VStack(alignment: .leading, spacing: 8) {
                        InfoRow(label: "Định dạng", value: book.fileFormat.rawValue.uppercased())
                        InfoRow(label: "Kích thước", value: formatFileSize(book.fileSize))
                        InfoRow(label: "Tiến độ", value: "\(Int(book.progress * 100))%")
                        if book.totalPages > 0 {
                            InfoRow(label: "Trang", value: "\(book.currentPage + 1) / \(book.totalPages)")
                        }
                    }
                    .padding(.horizontal)
                    
                    // Actions
                    VStack(spacing: 12) {
                        NavigationLink(destination: BookReaderView(book: book)) {
                            Text(book.currentPage > 0 ? "Tiếp tục đọc" : "Bắt đầu đọc")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            toggleFavorite()
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
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Xóa sách")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
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
            .alert("Xóa sách", isPresented: $showingDeleteAlert) {
                Button("Hủy", role: .cancel) { }
                Button("Xóa", role: .destructive) {
                    deleteBook()
                }
            } message: {
                Text("Bạn có chắc muốn xóa sách này?")
            }
        }
    }
    
    private func toggleFavorite() {
        var updatedBook = book
        updatedBook.favorite.toggle()
        bookDatabase.addBook(updatedBook)
    }
    
    private func deleteBook() {
        BookManager.shared.deleteBook(book)
        dismiss()
    }
    
    private func formatFileSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useKB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

