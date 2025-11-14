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

// BookCard moved to separate file BookCard.swift

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

// BookDetailView moved to separate file BookDetailView.swift

