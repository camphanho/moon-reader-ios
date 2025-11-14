//
//  PDFReaderView.swift
//  MoonReader
//
//  PDF Reader View - render PDF với PDFKit
//  Tương đương PDFReader.java trong Android
//

import SwiftUI
import PDFKit

struct PDFReaderView: View {
    let book: Book
    @State private var pdfDocument: PDFDocument?
    @State private var currentPage: Int = 0
    @State private var showingMenu = false
    @State private var showingAnnotations = false
    
    var body: some View {
        ZStack {
            if let document = pdfDocument {
                PDFViewRepresentable(document: document, currentPage: $currentPage)
                    .gesture(
                        DragGesture(minimumDistance: 50)
                            .onEnded { value in
                                handleSwipe(value)
                            }
                    )
                
                // Menu overlay
                if showingMenu {
                    PDFMenuOverlay(
                        currentPage: currentPage,
                        totalPages: document.pageCount,
                        onPrevious: { goToPreviousPage() },
                        onNext: { goToNextPage() },
                        onAnnotations: { showingAnnotations = true },
                        onClose: { }
                    )
                }
            } else {
                ProgressView()
            }
        }
        .onTapGesture {
            withAnimation {
                showingMenu.toggle()
            }
        }
        .onAppear {
            loadPDF()
        }
        .sheet(isPresented: $showingAnnotations) {
            PDFAnnotationsView(document: pdfDocument)
        }
    }
    
    private func loadPDF() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let booksFolder = documentsURL.appendingPathComponent("Books")
        let fileURL = booksFolder.appendingPathComponent(book.filename)
        
        if let document = PDFDocument(url: fileURL) {
            pdfDocument = document
            currentPage = book.currentPage
        }
    }
    
    private func handleSwipe(_ value: DragGesture.Value) {
        if value.translation.width > 100 {
            goToPreviousPage()
        } else if value.translation.width < -100 {
            goToNextPage()
        }
    }
    
    private func goToPreviousPage() {
        guard pdfDocument != nil, currentPage > 0 else { return }
        currentPage -= 1
        saveReadingPosition()
    }
    
    private func goToNextPage() {
        guard let document = pdfDocument, currentPage < document.pageCount - 1 else { return }
        currentPage += 1
        saveReadingPosition()
    }
    
    private func saveReadingPosition() {
        var updatedBook = book
        updatedBook.currentPage = currentPage
        updatedBook.totalPages = pdfDocument?.pageCount ?? 0
        BookDatabase.shared.addBook(updatedBook)
    }
}

struct PDFViewRepresentable: UIViewRepresentable {
    let document: PDFDocument
    @Binding var currentPage: Int
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal
        pdfView.usePageViewController(true)
        
        // Go to current page
        if currentPage < document.pageCount {
            if let page = document.page(at: currentPage) {
                pdfView.go(to: page)
            }
        }
        
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        if currentPage < document.pageCount {
            if let page = document.page(at: currentPage) {
                pdfView.go(to: page)
            }
        }
    }
}

struct PDFMenuOverlay: View {
    let currentPage: Int
    let totalPages: Int
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onAnnotations: () -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button(action: onClose) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Spacer()
                
                Text("\(currentPage + 1) / \(totalPages)")
                    .font(.headline)
                
                Spacer()
                
                Button(action: onAnnotations) {
                    Image(systemName: "pencil")
                        .font(.title3)
                }
            }
            .padding()
            .background(Color(.systemBackground).opacity(0.9))
            
            Spacer()
            
            HStack {
                Button(action: onPrevious) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Spacer()
                
                Button(action: onNext) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding()
            .background(Color(.systemBackground).opacity(0.9))
        }
    }
}

struct PDFAnnotationsView: View {
    let document: PDFDocument?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                if let document = document {
                    ForEach(0..<document.pageCount, id: \.self) { index in
                        pageSection(document: document, index: index)
                    }
                }
            }
            .navigationTitle("Ghi chú PDF")
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
    
    @ViewBuilder
    private func pageSection(document: PDFDocument, index: Int) -> some View {
        if let page = document.page(at: index) {
            let annotations = page.annotations
            if !annotations.isEmpty {
                Section(header: Text("Trang \(index + 1)")) {
                    ForEach(annotations.indices, id: \.self) { idx in
                        Text(annotations[idx].contents ?? "Annotation")
                    }
                }
            }
        }
    }
}

import UIKit

