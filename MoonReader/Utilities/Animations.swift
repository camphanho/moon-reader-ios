//
//  Animations.swift
//  MoonReader
//
//  Custom Animations - animations cho app
//

import SwiftUI

extension View {
    func fadeIn(duration: Double = 0.3) -> some View {
        self.modifier(FadeInModifier(duration: duration))
    }
    
    func slideIn(from edge: Edge, duration: Double = 0.3) -> some View {
        self.modifier(SlideInModifier(edge: edge, duration: duration))
    }
    
    func scaleIn(duration: Double = 0.3) -> some View {
        self.modifier(ScaleInModifier(duration: duration))
    }
}

struct FadeInModifier: ViewModifier {
    let duration: Double
    @State private var opacity: Double = 0
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: duration)) {
                    opacity = 1
                }
            }
    }
}

struct SlideInModifier: ViewModifier {
    let edge: Edge
    let duration: Double
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .offset(x: edge == .leading ? -offset : (edge == .trailing ? offset : 0),
                   y: edge == .top ? -offset : (edge == .bottom ? offset : 0))
            .onAppear {
                offset = 100
                withAnimation(.easeOut(duration: duration)) {
                    offset = 0
                }
            }
    }
}

struct ScaleInModifier: ViewModifier {
    let duration: Double
    @State private var scale: CGFloat = 0.8
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.spring(response: duration, dampingFraction: 0.6)) {
                    scale = 1
                }
            }
    }
}

// Page turn animation
struct PageTurnEffect: GeometryEffect {
    var progress: Double
    var direction: PageTurnDirection
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let rotation = direction == .forward ? -progress * .pi / 2 : progress * .pi / 2
        let transform = CGAffineTransform(rotationAngle: rotation)
            .translatedBy(x: -size.width / 2, y: -size.height / 2)
            .translatedBy(x: size.width / 2, y: size.height / 2)
        
        return ProjectionTransform(transform)
    }
}

// Shake animation for errors
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

extension View {
    func shake(times: Int = 3) -> some View {
        self.modifier(ShakeModifier(times: times))
    }
}

struct ShakeModifier: ViewModifier {
    @State private var animatableData: CGFloat = 0
    let times: Int
    
    func body(content: Content) -> some View {
        content
            .modifier(ShakeEffect(animatableData: animatableData))
            .onAppear {
                withAnimation(.default.repeatCount(times, autoreverses: true)) {
                    animatableData = 1
                }
            }
    }
}

