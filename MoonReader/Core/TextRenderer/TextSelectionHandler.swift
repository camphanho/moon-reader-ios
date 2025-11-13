//
//  TextSelectionHandler.swift
//  MoonReader
//
//  Text Selection Handler - xử lý text selection và highlight
//  Tương đương logic highlight trong ActivityTxt.java
//

import Foundation
import UIKit
import SwiftUI

class TextSelectionHandler: ObservableObject {
    @Published var selectedRange: NSRange?
    @Published var selectedText: String?
    @Published var showHighlightMenu = false
    
    var onTextSelected: ((String, NSRange) -> Void)?
    var onHighlight: ((String, NSRange, HighlightColor) -> Void)?
    
    func handleSelection(_ range: NSRange, in text: String) {
        selectedRange = range
        selectedText = (text as NSString).substring(with: range)
        showHighlightMenu = true
    }
    
    func createHighlight(
        text: String,
        range: NSRange,
        color: HighlightColor
    ) -> Bookmark {
        let bookmark = Bookmark(
            bookId: UUID(), // Will be set by caller
            bookFilename: "",
            chapter: 0, // Will be set by caller
            position: Double(range.location),
            splitIndex: 0,
            highlightLength: range.length,
            highlightColor: color,
            time: Date(),
            note: nil,
            originalText: text,
            isUnderline: false,
            isStrikethrough: false
        )
        
        return bookmark
    }
}

// UIViewRepresentable để wrap UITextView với text selection
struct SelectableTextView: UIViewRepresentable {
    let attributedText: NSAttributedString
    let theme: ReaderTheme
    let onTextSelected: (String, NSRange) -> Void
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = theme.backgroundColor.uiColor
        textView.textColor = theme.textColor.uiColor
        textView.attributedText = attributedText
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        // Add long press gesture for selection
        let longPress = UILongPressGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleLongPress(_:))
        )
        textView.addGestureRecognizer(longPress)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedText
        uiView.backgroundColor = theme.backgroundColor.uiColor
        uiView.textColor = theme.textColor.uiColor
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onTextSelected: onTextSelected)
    }
    
    class Coordinator: NSObject {
        let onTextSelected: (String, NSRange) -> Void
        
        init(onTextSelected: @escaping (String, NSRange) -> Void) {
            self.onTextSelected = onTextSelected
        }
        
        @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            guard let textView = gesture.view as? UITextView else { return }
            
            let point = gesture.location(in: textView)
            if let position = textView.closestPosition(to: point),
               let range = textView.textRange(from: position, to: position) {
                // Select word at position
                textView.selectedTextRange = range
                if let selectedRange = textView.selectedTextRange,
                   let selectedText = textView.text(in: selectedRange) {
                    let nsRange = textView.nsRange(from: selectedRange)
                    onTextSelected(selectedText, nsRange)
                }
            }
        }
    }
}

extension UITextView {
    func nsRange(from textRange: UITextRange) -> NSRange {
        let start = offset(from: beginningOfDocument, to: textRange.start)
        let end = offset(from: beginningOfDocument, to: textRange.end)
        return NSRange(location: start, length: end - start)
    }
}

