//
//  DictionaryView.swift
//  MoonReader
//
//  Dictionary View - tra từ điển
//

import SwiftUI

struct DictionaryView: View {
    let word: String
    @State private var definitions: [DictionaryDefinition] = []
    @State private var isLoading = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                if isLoading {
                    ProgressView()
                        .padding()
                } else if definitions.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("Không tìm thấy định nghĩa")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(definitions) { definition in
                            DefinitionCard(definition: definition)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(word)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadDefinition()
            }
        }
    }
    
    private func loadDefinition() {
        isLoading = true
        
        // Placeholder - sẽ implement với dictionary API
        // Có thể sử dụng:
        // - iOS Dictionary framework
        // - Online dictionary API
        // - Offline dictionary database
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Mock data
            definitions = [
                DictionaryDefinition(
                    word: word,
                    partOfSpeech: "Danh từ",
                    definition: "Định nghĩa của từ \"\(word)\"",
                    example: "Ví dụ sử dụng từ này trong câu."
                )
            ]
            isLoading = false
        }
    }
}

struct DictionaryDefinition: Identifiable {
    let id = UUID()
    let word: String
    let partOfSpeech: String
    let definition: String
    let example: String?
}

struct DefinitionCard: View {
    let definition: DictionaryDefinition
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(definition.partOfSpeech)
                .font(.caption)
                .foregroundColor(.blue)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(4)
            
            Text(definition.definition)
                .font(.body)
            
            if let example = definition.example {
                Text("\"\(example)\"")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
                    .padding(.top, 4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

