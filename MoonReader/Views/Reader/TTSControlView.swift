//
//  TTSControlView.swift
//  MoonReader
//
//  TTS Control View - điều khiển Text-to-Speech
//

import SwiftUI
import AVFoundation

struct TTSControlView: View {
    @StateObject private var ttsService = TTSService.shared
    @State private var showingVoicePicker = false
    @State private var selectedText: String
    
    init(text: String = "") {
        _selectedText = State(initialValue: text)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Current text preview
            if !selectedText.isEmpty {
                Text(selectedText.prefix(100) + (selectedText.count > 100 ? "..." : ""))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // Control buttons
            HStack(spacing: 20) {
                // Stop button
                Button(action: {
                    ttsService.stopSpeaking()
                }) {
                    Image(systemName: "stop.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
                
                // Play/Pause button
                Button(action: {
                    if ttsService.isPaused {
                        ttsService.continueSpeaking()
                    } else if ttsService.isSpeaking {
                        ttsService.pauseSpeaking()
                    } else {
                        ttsService.startSpeaking(text: selectedText)
                    }
                }) {
                    Image(systemName: ttsService.isPaused ? "play.fill" : (ttsService.isSpeaking ? "pause.fill" : "play.fill"))
                        .font(.title)
                        .foregroundColor(.blue)
                }
                
                // Voice picker
                Button(action: {
                    showingVoicePicker = true
                }) {
                    Image(systemName: "person.wave.2.fill")
                        .font(.title3)
                }
            }
            .padding()
            
            // Speed control
            VStack(alignment: .leading, spacing: 8) {
                Text("Tốc độ đọc: \(String(format: "%.1f", ttsService.speakingRate))x")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Slider(value: Binding(
                    get: { Double(ttsService.speakingRate) },
                    set: { ttsService.setRate(Float($0)) }
                ), in: 0.3...0.8)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
        .sheet(isPresented: $showingVoicePicker) {
            VoicePickerView()
        }
    }
}

struct VoicePickerView: View {
    @StateObject private var ttsService = TTSService.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                // Vietnamese voices
                Section(header: Text("Tiếng Việt")) {
                    ForEach(ttsService.getVietnameseVoices(), id: \.identifier) { voice in
                        Button(action: {
                            ttsService.setVoice(voice)
                            dismiss()
                        }) {
                            HStack {
                                Text(voice.name)
                                Spacer()
                                if ttsService.selectedVoice?.identifier == voice.identifier {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                
                // Other voices
                Section(header: Text("Ngôn ngữ khác")) {
                    ForEach(ttsService.getAvailableVoices().prefix(20), id: \.identifier) { voice in
                        Button(action: {
                            ttsService.setVoice(voice)
                            dismiss()
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(voice.name)
                                    Text(voice.language)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if ttsService.selectedVoice?.identifier == voice.identifier {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Chọn giọng đọc")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") {
                        dismiss()
                    }
                }
            }
        }
    }
}

