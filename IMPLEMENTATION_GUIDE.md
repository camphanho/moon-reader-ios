# Hướng dẫn Implementation Moon Reader iOS

## Tổng quan

Dự án này port Moon Reader Pro từ Android sang iOS, giữ nguyên đầy đủ tính năng và giao diện.

## Cấu trúc đã tạo

```
MoonReader/
├── MoonReaderApp.swift          ✅ Entry point
├── Models/                      ✅
│   ├── Book.swift
│   ├── Bookmark.swift
│   ├── Note.swift
│   └── ReadingStatistics.swift
├── Core/
│   ├── Database/
│   │   └── BookDatabase.swift   ✅ SQLite manager
│   ├── Parsers/                 🚧
│   │   ├── BaseBookParser.swift ✅
│   │   ├── EPUBParser.swift     🚧 Cần hoàn thiện
│   │   └── TXTParser.swift      ✅
│   └── TextRenderer/
│       └── BookTextRenderer.swift ✅ Cơ bản
├── Views/
│   ├── Library/
│   │   └── BookShelfView.swift  ✅
│   ├── Reader/
│   │   ├── ReadingView.swift    ✅
│   │   └── ReaderSettingsView.swift ✅
│   └── Settings/
│       └── SettingsView.swift   ✅
└── Utilities/
    ├── ThemeManager.swift       ✅
    └── GestureHandler.swift     ✅
```

## Các bước tiếp theo

### Phase 1: Core Functionality (Ưu tiên cao)

#### 1.1 Hoàn thiện EPUB Parser
```swift
// Cần implement:
- Extract ZIP archive
- Parse OPF file để lấy metadata
- Parse NCX/NAV để lấy table of contents
- Extract HTML chapters
- Extract cover image
```

**Thư viện cần dùng:**
- ZIPFoundation hoặc ZipArchive
- XMLParser (built-in) hoặc AEXML

**Tham khảo Android code:**
- `com/flyersoft/books/Epub.java`

#### 1.2 Text Rendering Engine
```swift
// Cần implement:
- HTML to NSAttributedString conversion
- CSS parsing và application
- Image rendering trong text
- Table rendering
- Hyphenation
- Custom line breaking
```

**Tham khảo Android code:**
- `com/flyersoft/staticlayout/` package
- `MRTextView.java`, `MyHtml.java`, `MyLayout.java`

#### 1.3 Page Turning Logic
```swift
// Cần implement:
- Calculate pages từ text content
- Page navigation
- Page turning animations
- Scroll mode
- Dual page mode
```

**Tham khảo Android code:**
- `ActivityTxt.java` - page calculation logic
- `MRBookView.java` - WebView scrolling

### Phase 2: Reading Features

#### 2.1 Bookmark & Highlight
```swift
// Cần implement:
- Text selection
- Highlight với màu sắc
- Save bookmark
- Edit/Delete bookmark
- Show bookmarks list
```

**Tham khảo Android code:**
- `PrefEditBookmark.java`
- `PrefSelectHighlight.java`
- `HighlightLay.java`

#### 2.2 Search
```swift
// Cần implement:
- Search trong sách
- Highlight search results
- Navigate between results
- Search trong thư viện
```

**Tham khảo Android code:**
- `FuncSearch.java`
- `PrefSearch.java`

#### 2.3 Chapter Navigation
```swift
// Cần implement:
- Table of contents
- Chapter list
- Jump to chapter
- Chapter progress
```

**Tham khảo Android code:**
- `PrefChapters.java`

### Phase 3: Advanced Features

#### 3.1 PDF Support
```swift
// Sử dụng PDFKit (built-in)
- PDFDocument
- PDFView
- PDF annotation
```

**Tham khảo Android code:**
- `com/flyersoft/books/PDFReader.java`
- `com/radaee/` package

#### 3.2 Cloud Sync
```swift
// Cần implement:
- iCloud Documents
- Dropbox SDK
- WebDAV client
- Sync bookmarks
- Sync reading progress
```

**Tham khảo Android code:**
- `com/flyersoft/components/cloud/` package

#### 3.3 TTS
```swift
// Sử dụng AVSpeechSynthesizer
- Voice selection
- Speed control
- Pause/Resume
```

**Tham khảo Android code:**
- `BookTtsService.java`

## Mapping Android → iOS

### Activities → Views
- `ActivityMain` → `BookShelfView`
- `ActivityTxt` → `ReadingView`
- `Pref*` activities → `SettingsView` + sub-views

### Components → SwiftUI Views
- `BookShelfView` → `BookShelfView` (SwiftUI)
- `MRBookView` → `BookReaderView` (SwiftUI + UIKit)
- `CoverFlow` → SwiftUI custom view

### Database
- `BookDb.java` → `BookDatabase.swift`
- SQLite schema giữ nguyên

### Parsers
- `BaseEBook.java` → `BaseBookParser.swift`
- `Epub.java` → `EPUBParser.swift`
- `Fb2.java` → `FB2Parser.swift`
- etc.

## Dependencies cần thêm

### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.0"),
    // Dropbox SDK nếu cần
]
```

### CocoaPods (nếu dùng)
```ruby
pod 'ZipArchive'
pod 'DropboxSDK'
```

## Testing Strategy

1. **Unit Tests**: Parsers, Database operations
2. **UI Tests**: Navigation, gestures
3. **Integration Tests**: Full reading flow

## Performance Optimization

1. **Lazy Loading**: Chapters, images
2. **Caching**: Parsed books, rendered pages
3. **Background Processing**: Book parsing

## Notes

- SwiftUI cho UI hiện đại
- UIKit cho text rendering phức tạp (có thể dùng UIViewRepresentable)
- SQLite trực tiếp (có thể migrate sang Core Data sau)
- Protocol-oriented cho parsers (dễ extend)

