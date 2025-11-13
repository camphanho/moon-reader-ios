//
//  GestureHandler.swift
//  MoonReader
//
//  Gesture Handler - xử lý các gesture trong reading view
//  Tương đương gesture handlers trong ActivityTxt.java
//

import SwiftUI

struct ReadingGestureModifier: ViewModifier {
    let onSwipeLeft: () -> Void
    let onSwipeRight: () -> Void
    let onTap: () -> Void
    let onLongPress: () -> Void
    
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { value in
                        if value.translation.width > 100 {
                            onSwipeRight()
                        } else if value.translation.width < -100 {
                            onSwipeLeft()
                        }
                    }
            )
            .onTapGesture {
                onTap()
            }
            .onLongPressGesture {
                onLongPress()
            }
    }
}

extension View {
    func readingGestures(
        onSwipeLeft: @escaping () -> Void,
        onSwipeRight: @escaping () -> Void,
        onTap: @escaping () -> Void,
        onLongPress: @escaping () -> Void = {}
    ) -> some View {
        modifier(ReadingGestureModifier(
            onSwipeLeft: onSwipeLeft,
            onSwipeRight: onSwipeRight,
            onTap: onTap,
            onLongPress: onLongPress
        ))
    }
}

