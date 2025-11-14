//
//  CloudSyncView.swift
//  MoonReader
//
//  Cloud Sync View - quản lý đồng bộ đám mây
//

import SwiftUI

struct CloudSyncView: View {
    @StateObject private var cloudSync = iCloudSync.shared
    @State private var showingSyncAlert = false
    @State private var syncError: String?
    
    var body: some View {
        List {
            // iCloud Section
            Section(header: Text("iCloud Drive")) {
                HStack {
                    Image(systemName: "icloud")
                        .foregroundColor(.blue)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("iCloud Sync")
                            .font(.headline)
                        
                        if cloudSync.checkiCloudAvailability() {
                            Text("Đã kết nối")
                                .font(.caption)
                                .foregroundColor(.green)
                        } else {
                            Text("Chưa kết nối")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Spacer()
                    
                    if cloudSync.isSyncing {
                        ProgressView()
                    } else {
                        Button("Đồng bộ") {
                            Task {
                                await syncToiCloud()
                            }
                        }
                        .disabled(!cloudSync.checkiCloudAvailability())
                    }
                }
                
                if cloudSync.isSyncing {
                    ProgressView(value: cloudSync.syncProgress)
                        .padding(.vertical, 8)
                }
                
                if let lastSync = cloudSync.lastSyncDate {
                    Text("Lần đồng bộ cuối: \(formatDate(lastSync))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Dropbox Section (Placeholder)
            Section(header: Text("Dropbox")) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dropbox Sync")
                            .font(.headline)
                        Text("Sắp có")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button("Kết nối") {
                        // Placeholder
                    }
                    .disabled(true)
                }
            }
            
            // WebDAV Section (Placeholder)
            Section(header: Text("WebDAV")) {
                HStack {
                    Image(systemName: "server.rack")
                        .foregroundColor(.blue)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("WebDAV Sync")
                            .font(.headline)
                        Text("Sắp có")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button("Kết nối") {
                        // Placeholder
                    }
                    .disabled(true)
                }
            }
        }
        .navigationTitle("Đồng bộ đám mây")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Lỗi đồng bộ", isPresented: .constant(syncError != nil), presenting: syncError) { _ in
            Button("OK") {
                syncError = nil
            }
        } message: { error in
            Text(error)
        }
    }
    
    private func syncToiCloud() async {
        do {
            try await cloudSync.syncBooks()
        } catch {
            syncError = error.localizedDescription
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "vi_VN")
        return formatter.string(from: date)
    }
}

