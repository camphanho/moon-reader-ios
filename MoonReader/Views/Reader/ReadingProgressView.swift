//
//  ReadingProgressView.swift
//  MoonReader
//
//  Reading Progress View - hiển thị tiến độ đọc
//

import SwiftUI

struct ReadingProgressView: View {
    let currentPage: Int
    let totalPages: Int
    let progress: Double
    
    var body: some View {
        VStack(spacing: 4) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 4)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * CGFloat(progress), height: 4)
                }
            }
            .frame(height: 4)
            
            // Page info
            HStack {
                Text("Trang \(currentPage + 1) / \(totalPages)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct ChapterProgressView: View {
    let currentChapter: Int
    let totalChapters: Int
    let chapterTitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(chapterTitle)
                .font(.headline)
                .lineLimit(1)
            
            HStack {
                Text("Chương \(currentChapter + 1) / \(totalChapters)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                ProgressView(value: Double(currentChapter + 1), total: Double(totalChapters))
                    .frame(width: 100)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

