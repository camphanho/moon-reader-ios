//
//  ReaderSettingsView.swift
//  MoonReader
//
//  Reader Settings View - tương đương PrefVisual, PrefTheme, PrefControl trong Android
//

import SwiftUI

struct ReaderSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ReaderViewModel
    @State private var fontSize: Int
    @State private var fontName: String
    @State private var lineSpacing: Int
    @State private var selectedTheme: ReaderTheme
    @State private var margin: CGFloat
    @State private var alignment: TextAlignment
    
    init(viewModel: ReaderViewModel) {
        self.viewModel = viewModel
        _fontSize = State(initialValue: viewModel.readerSettings.fontSize)
        _fontName = State(initialValue: viewModel.readerSettings.fontName)
        _lineSpacing = State(initialValue: viewModel.readerSettings.lineSpacing)
        _selectedTheme = State(initialValue: viewModel.readerSettings.theme)
        _margin = State(initialValue: viewModel.readerSettings.margin)
        _alignment = State(initialValue: viewModel.readerSettings.alignment)
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Font
                Section(header: Text("Font")) {
                    NavigationLink(destination: FontPickerView(selectedFont: $fontName)) {
                        HStack {
                            Text("Font chữ")
                            Spacer()
                            Text(fontName)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Font size
                Section(header: Text("Cỡ chữ")) {
                    Stepper("\(fontSize) pt", value: $fontSize, in: 12...32)
                }
                
                // Line spacing
                Section(header: Text("Khoảng cách dòng")) {
                    Stepper("\(lineSpacing) pt", value: $lineSpacing, in: 0...20)
                }
                
                // Theme
                Section(header: Text("Giao diện")) {
                    Picker("Theme", selection: $selectedTheme) {
                        Text("Ngày").tag(ReaderTheme.day)
                        Text("Đêm").tag(ReaderTheme.night)
                        Text("AMOLED").tag(ReaderTheme.amoled)
                        Text("Sepia").tag(ReaderTheme.sepia)
                    }
                }
                
                // Margins
                Section(header: Text("Lề trang")) {
                    Slider(value: $margin, in: 10...50)
                    Text("\(Int(margin)) pt")
                }
                
                // Text alignment
                Section(header: Text("Căn lề")) {
                    Picker("Alignment", selection: $alignment) {
                        Text("Trái").tag(TextAlignment.leading)
                        Text("Giữa").tag(TextAlignment.center)
                        Text("Phải").tag(TextAlignment.trailing)
                        Text("Đều").tag(TextAlignment.justified)
                    }
                }
                
                // Auto scroll
                Section(header: Text("Tự động cuộn")) {
                    Toggle("Bật tự động cuộn", isOn: .constant(false))
                    
                    if true { // Replace with actual state
                        Picker("Chế độ", selection: .constant(AutoScrollMode.byLine)) {
                            Text("Tắt").tag(AutoScrollMode.off)
                            Text("Theo pixel").tag(AutoScrollMode.byPixel)
                            Text("Theo dòng").tag(AutoScrollMode.byLine)
                            Text("Theo trang").tag(AutoScrollMode.byPage)
                            Text("Cuộn liên tục").tag(AutoScrollMode.rollingBlind)
                        }
                        
                        HStack {
                            Text("Tốc độ")
                            Spacer()
                            Slider(value: .constant(1.0), in: 0.5...5.0)
                            Text("1.0x")
                                .frame(width: 50)
                        }
                    }
                }
            }
            .navigationTitle("Cài đặt đọc")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Xong") {
                        // Update viewModel settings
                        viewModel.readerSettings.fontSize = fontSize
                        viewModel.readerSettings.fontName = fontName
                        viewModel.readerSettings.lineSpacing = lineSpacing
                        viewModel.readerSettings.theme = selectedTheme
                        viewModel.readerSettings.margin = margin
                        viewModel.readerSettings.alignment = alignment
                        
                        // Reload current chapter with new settings
                        viewModel.loadChapter(at: viewModel.currentChapterIndex)
                        
                        dismiss()
                    }
                }
            }
        }
    }
}

