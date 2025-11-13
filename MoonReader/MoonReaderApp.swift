//
//  MoonReaderApp.swift
//  MoonReader
//
//  Created based on Android Moon Reader Pro
//

import SwiftUI

@main
struct MoonReaderApp: App {
    @StateObject private var bookDatabase = BookDatabase.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookDatabase)
                .preferredColorScheme(.light) // Sẽ được điều khiển bởi theme settings
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var bookDatabase: BookDatabase
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BookShelfView()
                .tabItem {
                    Label("Thư viện", systemImage: "books.vertical")
                }
                .tag(0)
            
            ReadingView()
                .tabItem {
                    Label("Đọc sách", systemImage: "book")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Cài đặt", systemImage: "gearshape")
                }
                .tag(2)
        }
    }
}

