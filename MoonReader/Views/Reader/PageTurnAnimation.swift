//
//  PageTurnAnimation.swift
//  MoonReader
//
//  Page Turn Animation - animation khi chuyển trang
//  Tương đương page flip animations trong Android
//

import SwiftUI

enum PageTurnStyle {
    case none
    case slide
    case curl
    case fade
    case scroll
}

struct PageTurnModifier: ViewModifier {
    let style: PageTurnStyle
    let isTurning: Bool
    let direction: PageTurnDirection
    
    func body(content: Content) -> some View {
        switch style {
        case .none:
            content
        case .slide:
            content
                .offset(x: isTurning ? (direction == .forward ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width) : 0)
                .animation(.easeInOut(duration: 0.3), value: isTurning)
        case .fade:
            content
                .opacity(isTurning ? 0 : 1)
                .animation(.easeInOut(duration: 0.2), value: isTurning)
        case .curl:
            // Curl animation would require more complex implementation
            content
                .rotation3DEffect(
                    .degrees(isTurning ? (direction == .forward ? -15 : 15) : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
                .animation(.easeInOut(duration: 0.3), value: isTurning)
        case .scroll:
            content
        }
    }
}

enum PageTurnDirection {
    case forward
    case backward
}

extension View {
    func pageTurn(style: PageTurnStyle, isTurning: Bool, direction: PageTurnDirection) -> some View {
        modifier(PageTurnModifier(style: style, isTurning: isTurning, direction: direction))
    }
}

