//
//  SearchView.swift
//  MoonReader
//
//  Search View - tìm kiếm trong sách
//  Tương đương FuncSearch.java trong Android
//

import SwiftUI

struct SearchView: View {
    let book: Book
    let chapters: [Chapter]
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @State private var searchResults: [SearchResult] = []
    @State private var selectedResult: SearchResult?
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Tìm kiếm...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onSubmit {
                            performSearch()
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            searchResults = []
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Button(action: performSearch) {
                        Text("Tìm")
                            .fontWeight(.semibold)
                    }
                    .disabled(searchText.isEmpty || isSearching)
                }
                .padding()
                .background(Color(.systemGray6))
                
                // Search results
                if isSearching {
                    ProgressView()
                        .padding()
                } else if searchResults.isEmpty && !searchText.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("Không tìm thấy kết quả")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if searchResults.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("Nhập từ khóa để tìm kiếm")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(Array(searchResults.enumerated()), id: \.element.chapterId) { index, result in
                            SearchResultRow(result: result, index: index + 1)
                                .onTapGesture {
                                    selectedResult = result
                                    // Navigate to result
                                    isPresented = false
                                }
                        }
                    }
                }
            }
            .navigationTitle("Tìm kiếm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    private func performSearch() {
        guard !searchText.isEmpty else { return }
        
        isSearching = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let results = BookSearchEngine.search(
                query: searchText,
                in: chapters
            )
            
            DispatchQueue.main.async {
                searchResults = results
                isSearching = false
            }
        }
    }
}

struct SearchResultRow: View {
    let result: SearchResult
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Chapter title
            Text(result.chapterTitle)
                .font(.headline)
                .foregroundColor(.primary)
            
            // Context with highlighted match
            Text(result.context)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            // Match info
            HStack {
                Text("Kết quả \(index)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Chương \(result.chapterIndex + 1)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

