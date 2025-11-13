//
//  BookCard.swift
//  MoonReader
//
//  Book Card - hiển thị sách trong grid/list
//  Enhanced với animations và haptic feedback
//

import SwiftUI

struct BookCard: View {
    let book: Book
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Cover Image
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(2/3, contentMode: .fit)
                
                if let coverPath = book.coverImagePath,
                   let image = UIImage(contentsOfFile: coverPath) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                        .cornerRadius(8)
                } else {
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                }
                
                // Progress indicator
                if book.progress > 0 && book.progress < 1 {
                    VStack {
                        Spacer()
                        ProgressView(value: book.progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .padding(.horizontal, 8)
                            .padding(.bottom, 4)
                    }
                }
            }
            
            // Title
            Text(book.title)
                .font(.caption)
                .lineLimit(2)
                .foregroundColor(.primary)
            
            // Author
            if !book.author.isEmpty {
                Text(book.author)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
            if pressing {
                HapticFeedback.generate(.light)
            }
        }, perform: {})
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(book.title) bởi \(book.author)")
    }
}

