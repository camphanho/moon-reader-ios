//
//  BrightnessControlView.swift
//  MoonReader
//
//  Brightness Control - điều khiển độ sáng màn hình
//  Tương đương brightness control trong Android
//

import SwiftUI

struct BrightnessControlView: View {
    @State private var brightness: Double = UIScreen.main.brightness
    @State private var isVisible = false
    
    var body: some View {
        VStack {
            Spacer()
            
            if isVisible {
                VStack(spacing: 12) {
                    Image(systemName: "sun.max.fill")
                        .font(.title)
                        .foregroundColor(.yellow)
                    
                    Slider(value: $brightness, in: 0...1)
                        .frame(width: 200)
                        .onChange(of: brightness) { newValue in
                            UIScreen.main.brightness = newValue
                        }
                    
                    Text("\(Int(brightness * 100))%")
                        .font(.headline)
                }
                .padding()
                .background(Color(.systemBackground).opacity(0.9))
                .cornerRadius(12)
                .shadow(radius: 10)
                .transition(.opacity)
            }
        }
        .onAppear {
            brightness = UIScreen.main.brightness
        }
    }
    
    func show() {
        withAnimation {
            isVisible = true
        }
        
        // Auto hide after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            hide()
        }
    }
    
    func hide() {
        withAnimation {
            isVisible = false
        }
    }
}

