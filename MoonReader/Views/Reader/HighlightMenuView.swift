//
//  HighlightMenuView.swift
//  MoonReader
//
//  Highlight Menu - menu hiển thị khi chọn text
//  Tương đương PopupNoteLay.java trong Android
//

import SwiftUI

struct HighlightMenuView: View {
    let selectedText: String
    let onHighlight: (HighlightColor) -> Void
    let onNote: () -> Void
    let onCopy: () -> Void
    let onShare: () -> Void
    let onDictionary: () -> Void
    @State private var showingDictionary = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Selected text preview
            Text(selectedText)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
            
            Divider()
            
            // Action buttons
            VStack(spacing: 12) {
                // Highlight colors
                HStack(spacing: 16) {
                    ForEach(HighlightColor.allCases, id: \.self) { color in
                        Button(action: {
                            onHighlight(color)
                            dismiss()
                        }) {
                            Circle()
                                .fill(color.color)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.vertical, 8)
                
                Divider()
                
                // Other actions
                VStack(spacing: 0) {
                    HighlightMenuButton(
                        icon: "note.text",
                        title: "Ghi chú",
                        action: {
                            onNote()
                            dismiss()
                        }
                    )
                    
                    HighlightMenuButton(
                        icon: "doc.on.doc",
                        title: "Sao chép",
                        action: {
                            onCopy()
                            dismiss()
                        }
                    )
                    
                    HighlightMenuButton(
                        icon: "square.and.arrow.up",
                        title: "Chia sẻ",
                        action: {
                            onShare()
                            dismiss()
                        }
                    )
                    
                    HighlightMenuButton(
                        icon: "book",
                        title: "Từ điển",
                        action: {
                            showingDictionary = true
                        }
                    )
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
        .sheet(isPresented: $showingDictionary) {
            DictionaryView(word: selectedText)
        }
    }
}

struct HighlightMenuButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                Text(title)
                Spacer()
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

