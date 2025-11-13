//
//  SettingsView.swift
//  MoonReader
//
//  Settings View - tương đương các Pref* activities trong Android
//

import SwiftUI

struct SettingsView: View {
    @State private var showingAbout = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Đọc sách")) {
                    NavigationLink(destination: Text("Cài đặt đọc")) {
                        Label("Cài đặt đọc", systemImage: "textformat")
                    }
                    
                    NavigationLink(destination: Text("Cài đặt giao diện")) {
                        Label("Giao diện", systemImage: "paintbrush")
                    }
                    
                    NavigationLink(destination: Text("Cài đặt điều khiển")) {
                        Label("Điều khiển", systemImage: "hand.tap")
                    }
                }
                
                Section(header: Text("Thư viện")) {
                    NavigationLink(destination: Text("Quản lý thư viện")) {
                        Label("Thư viện", systemImage: "books.vertical")
                    }
                    
                    NavigationLink(destination: ReadingStatisticsView()) {
                        Label("Thống kê", systemImage: "chart.bar")
                    }
                    
                    NavigationLink(destination: ReadingCalendarView()) {
                        Label("Lịch đọc", systemImage: "calendar")
                    }
                }
                
                Section(header: Text("Đồng bộ")) {
                    NavigationLink(destination: CloudSyncView()) {
                        Label("Đồng bộ đám mây", systemImage: "icloud")
                    }
                }
                
                Section(header: Text("Thư viện trực tuyến")) {
                    NavigationLink(destination: OPDSCatalogView()) {
                        Label("OPDS Catalog", systemImage: "network")
                    }
                }
                
                Section(header: Text("Khác")) {
                    Button(action: { showingAbout = true }) {
                        Label("Giới thiệu", systemImage: "info.circle")
                    }
                }
            }
            .navigationTitle("Cài đặt")
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "moon.stars")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Moon Reader")
                    .font(.title)
                    .bold()
                
                Text("Version 1.0")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Ứng dụng đọc sách được port từ Moon Reader Pro Android")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Giới thiệu")
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

