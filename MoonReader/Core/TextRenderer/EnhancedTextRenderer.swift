//
//  EnhancedTextRenderer.swift
//  MoonReader
//
//  Enhanced Text Renderer - cải thiện text rendering với UITextView
//  Tương đương MRTextView.java trong Android
//

import UIKit
import SwiftUI

struct EnhancedTextView: UIViewRepresentable {
    let attributedText: NSAttributedString
    let theme: ReaderTheme
    let margin: CGFloat
    let onTextSelected: ((String, NSRange) -> Void)?
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = theme.backgroundColor.uiColor
        textView.textColor = theme.textColor.uiColor
        textView.attributedText = attributedText
        textView.textContainerInset = UIEdgeInsets(
            top: margin,
            left: margin,
            bottom: margin,
            right: margin
        )
        textView.textContainer.lineFragmentPadding = 0
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        
        // Add selection gesture
        let longPress = UILongPressGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleLongPress(_:))
        )
        textView.addGestureRecognizer(longPress)
        
        // Add tap gesture for menu toggle
        let tap = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        tap.numberOfTapsRequired = 1
        textView.addGestureRecognizer(tap)
        
        context.coordinator.textView = textView
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedText
        uiView.backgroundColor = theme.backgroundColor.uiColor
        uiView.textColor = theme.textColor.uiColor
        uiView.textContainerInset = UIEdgeInsets(
            top: margin,
            left: margin,
            bottom: margin,
            right: margin
        )
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onTextSelected: onTextSelected)
    }
    
    class Coordinator: NSObject {
        var textView: UITextView?
        let onTextSelected: ((String, NSRange) -> Void)?
        
        init(onTextSelected: ((String, NSRange) -> Void)?) {
            self.onTextSelected = onTextSelected
        }
        
        @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            guard let textView = gesture.view as? UITextView,
                  gesture.state == .began else { return }
            
            let point = gesture.location(in: textView)
            if let position = textView.closestPosition(to: point) {
                // Select word at position
                textView.selectedTextRange = textView.textRange(
                    from: position,
                    to: position
                )
                
                // Expand selection to word boundaries
                if let wordRange = textView.tokenizer.rangeEnclosingPosition(
                    position,
                    with: .word,
                    inDirection: .storage(.forward)
                ) {
                    textView.selectedTextRange = wordRange
                    
                    if let selectedRange = textView.selectedTextRange,
                       let selectedText = textView.text(in: selectedRange) {
                        let nsRange = textView.nsRange(from: selectedRange)
                        onTextSelected?(selectedText, nsRange)
                    }
                }
            }
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            // Handle tap for menu toggle
            // This will be handled by parent view
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

