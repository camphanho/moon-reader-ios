//
//  OPDSCatalogView.swift
//  MoonReader
//
//  OPDS Catalog View - duyệt thư viện trực tuyến
//

import SwiftUI

struct OPDSCatalogView: View {
    @StateObject private var opdsClient = OPDSClient.shared
    @State private var catalogs: [OPDSCatalog] = []
    @State private var showingAddCatalog = false
    @State private var newCatalogURL = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(catalogs) { catalog in
                    NavigationLink(destination: OPDSFeedView(catalog: catalog)) {
                        CatalogRow(catalog: catalog)
                    }
                }
                .onDelete(perform: deleteCatalogs)
                
                Button(action: {
                    showingAddCatalog = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                        Text("Thêm thư viện")
                    }
                }
            }
            .navigationTitle("Thư viện trực tuyến")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddCatalog) {
                AddOPDSCatalogView(catalogURL: $newCatalogURL) {
                    addCatalog()
                }
            }
            .onAppear {
                loadCatalogs()
            }
        }
    }
    
    private func loadCatalogs() {
        // Load from UserDefaults or database
        // Placeholder
        catalogs = [
            OPDSCatalog(
                id: UUID(),
                name: "Standard Ebooks",
                url: URL(string: "https://standardebooks.org/opds/all")!,
                description: "Free, public domain ebooks"
            )
        ]
    }
    
    private func addCatalog() {
        guard let url = URL(string: newCatalogURL) else { return }
        
        let catalog = OPDSCatalog(
            id: UUID(),
            name: url.host ?? "New Catalog",
            url: url,
            description: ""
        )
        
        catalogs.append(catalog)
        newCatalogURL = ""
        showingAddCatalog = false
    }
    
    private func deleteCatalogs(at offsets: IndexSet) {
        catalogs.remove(atOffsets: offsets)
    }
}

struct OPDSCatalog: Identifiable {
    let id: UUID
    let name: String
    let url: URL
    let description: String
}

struct CatalogRow: View {
    let catalog: OPDSCatalog
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(catalog.name)
                .font(.headline)
            
            Text(catalog.url.absoluteString)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            if !catalog.description.isEmpty {
                Text(catalog.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct OPDSFeedView: View {
    let catalog: OPDSCatalog
    @State private var feed: OPDSFeed?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if let error = errorMessage {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    
                    Text("Lỗi")
                        .font(.headline)
                    
                    Text(error)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            } else if let feed = feed {
                List {
                    ForEach(feed.entries, id: \.id) { entry in
                        OPDSBookRow(entry: entry)
                    }
                }
            }
        }
        .navigationTitle(catalog.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadFeed()
        }
    }
    
    private func loadFeed() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedFeed = try await OPDSClient.shared.fetchFeed(from: catalog.url)
                await MainActor.run {
                    feed = fetchedFeed
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}

struct OPDSBookRow: View {
    let entry: OPDSEntry
    @State private var isDownloading = false
    
    var body: some View {
        HStack {
            // Cover image placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 90)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title)
                    .font(.headline)
                    .lineLimit(2)
                
                if !entry.authors.isEmpty {
                    Text(entry.authors.joined(separator: ", "))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let summary = entry.summary {
                    Text(summary)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Button(action: {
                downloadBook()
            }) {
                if isDownloading {
                    ProgressView()
                } else {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .disabled(isDownloading)
        }
        .padding(.vertical, 4)
    }
    
    private func downloadBook() {
        isDownloading = true
        
        Task {
            do {
                let fileURL = try await OPDSClient.shared.downloadBook(entry)
                // Import book
                _ = try await BookManager.shared.importBooks(from: [fileURL])
                isDownloading = false
            } catch {
                isDownloading = false
                // Show error
            }
        }
    }
}

struct AddOPDSCatalogView: View {
    @Binding var catalogURL: String
    let onAdd: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("URL thư viện")) {
                    TextField("https://example.com/opds", text: $catalogURL)
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                }
                
                Section {
                    Button("Thêm") {
                        onAdd()
                        dismiss()
                    }
                    .disabled(catalogURL.isEmpty)
                }
            }
            .navigationTitle("Thêm thư viện")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Hủy") {
                        dismiss()
                    }
                }
            }
        }
    }
}

