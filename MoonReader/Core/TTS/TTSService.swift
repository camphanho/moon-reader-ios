//
//  TTSService.swift
//  MoonReader
//
//  TTS Service - Text-to-Speech
//  Tương đương BookTtsService.java trong Android
//

import Foundation
import AVFoundation
import SwiftUI

class TTSService: NSObject, ObservableObject {
    static let shared = TTSService()
    
    @Published var isSpeaking = false
    @Published var isPaused = false
    @Published var currentText: String = ""
    @Published var speakingRate: Float = 0.5
    @Published var selectedVoice: AVSpeechSynthesisVoice?
    
    private let synthesizer = AVSpeechSynthesizer()
    private var currentUtterance: AVSpeechUtterance?
    private var currentRange: NSRange?
    
    override init() {
        super.init()
        synthesizer.delegate = self
        loadDefaultVoice()
    }
    
    func startSpeaking(text: String, range: NSRange? = nil) {
        stopSpeaking()
        
        currentText = text
        currentRange = range
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = speakingRate
        utterance.voice = selectedVoice
        utterance.volume = 1.0
        utterance.pitchMultiplier = 1.0
        
        currentUtterance = utterance
        synthesizer.speak(utterance)
        isSpeaking = true
        isPaused = false
    }
    
    func pauseSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .immediate)
            isPaused = true
        }
    }
    
    func continueSpeaking() {
        if isPaused {
            synthesizer.continueSpeaking()
            isPaused = false
        }
    }
    
    func stopSpeaking() {
        if synthesizer.isSpeaking || isPaused {
            synthesizer.stopSpeaking(at: .immediate)
            isSpeaking = false
            isPaused = false
            currentUtterance = nil
        }
    }
    
    func setRate(_ rate: Float) {
        speakingRate = rate
        if let utterance = currentUtterance {
            utterance.rate = rate
        }
    }
    
    func setVoice(_ voice: AVSpeechSynthesisVoice) {
        selectedVoice = voice
        if let utterance = currentUtterance {
            utterance.voice = voice
        }
    }
    
    func getAvailableVoices() -> [AVSpeechSynthesisVoice] {
        return AVSpeechSynthesisVoice.speechVoices()
    }
    
    func getVietnameseVoices() -> [AVSpeechSynthesisVoice] {
        return getAvailableVoices().filter { $0.language.hasPrefix("vi") }
    }
    
    private func loadDefaultVoice() {
        // Try to get Vietnamese voice first
        if let vietnameseVoice = getVietnameseVoices().first {
            selectedVoice = vietnameseVoice
        } else if let defaultVoice = AVSpeechSynthesisVoice(language: "en-US") {
            selectedVoice = defaultVoice
        } else {
            selectedVoice = AVSpeechSynthesisVoice.speechVoices().first
        }
    }
}

extension TTSService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeaking = true
        isPaused = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        isPaused = false
        currentUtterance = nil
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        isPaused = true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        isPaused = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
        isPaused = false
        currentUtterance = nil
    }
}

