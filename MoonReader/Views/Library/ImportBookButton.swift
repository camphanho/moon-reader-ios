//
//  ImportBookButton.swift
//  MoonReader
//
//  Import Book Button - mở file picker để import sách
//

import SwiftUI
import UniformTypeIdentifiers

struct ImportBookButton: View {
    @State private var showingFilePicker = false
    @State private var showingImportProgress = false
    @EnvironmentObject var bookDatabase: BookDatabase
    
    private let bookManager = BookManager.shared
    
    var body: some View {
        Button(action: {
            showingFilePicker = true
        }) {
            Image(systemName: "plus")
        }
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [
                .epub,
                .plainText,
                .pdf,
                .rtf,
                UTType(filenameExtension: "fb2") ?? .data,
                UTType(filenameExtension: "mobi") ?? .data,
                UTType(filenameExtension: "azw") ?? .data,
                UTType(filenameExtension: "azw3") ?? .data,
                UTType(filenameExtension: "chm") ?? .data,
                UTType(filenameExtension: "md") ?? .data,
                UTType(filenameExtension: "cbz") ?? .data,
                UTType(filenameExtension: "cbr") ?? .data,
                UTType(filenameExtension: "djvu") ?? .data
            ],
            allowsMultipleSelection: true
        ) { result in
            handleFileImport(result: result)
        }
        .sheet(isPresented: $showingImportProgress) {
            ImportProgressView()
        }
    }
    
    private func handleFileImport(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            Task {
                showingImportProgress = true
                do {
                    let books = try await bookManager.importBooks(from: urls)
                    print("Đã import \(books.count) sách")
                } catch {
                    print("Lỗi import: \(error)")
                }
                showingImportProgress = false
            }
        case .failure(let error):
            print("Lỗi chọn file: \(error)")
        }
    }
}

struct ImportProgressView: View {
    @EnvironmentObject var bookDatabase: BookDatabase
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                
                Text("Đang import sách...")
                    .font(.headline)
                
                if BookManager.shared.isImporting {
                    ProgressView(value: BookManager.shared.importProgress)
                        .padding(.horizontal)
                }
            }
            .padding()
            .navigationTitle("Import sách")
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

