//
//  FontPickerView.swift
//  MoonReader
//
//  Font Picker - chọn font cho reading
//

import SwiftUI

struct FontPickerView: View {
    @Binding var selectedFont: String
    let availableFonts = [
        "System",
        "Times New Roman",
        "Georgia",
        "Palatino",
        "Helvetica",
        "Arial",
        "Courier New",
        "Verdana"
    ]
    
    var body: some View {
        List {
            ForEach(availableFonts, id: \.self) { font in
                Button(action: {
                    selectedFont = font
                }) {
                    HStack {
                        Text(font)
                            .font(font == "System" ? .system(.body) : .custom(font, size: 17))
                        
                        Spacer()
                        
                        if selectedFont == font {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Chọn font")
        .navigationBarTitleDisplayMode(.inline)
    }
}

