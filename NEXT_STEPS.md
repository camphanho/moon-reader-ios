# Các bước tiếp theo - Moon Reader iOS

## ✅ Đã hoàn thành trong session này

### 1. Core Infrastructure
- ✅ Book Models (Book, Bookmark, Note, ReadingStatistics)
- ✅ BookDatabase với SQLite
- ✅ BookManager - quản lý import sách
- ✅ BookParserFactory - factory pattern cho parsers

### 2. Book Parsers
- ✅ BaseBookParser protocol
- ✅ TXTParser - hoàn chỉnh
- ✅ EPUBParser - structure đầy đủ (cần ZIP library)
- ✅ PDFParser - sử dụng PDFKit
- ✅ RTFParser - sử dụng NSAttributedString
- ✅ MDParser - parse Markdown
- ✅ FB2Parser, MOBIParser, DOCXParser, CHMParser, ComicParser, DJVUParser - structure cơ bản

### 3. UI Components
- ✅ BookShelfView với import button
- ✅ ImportBookButton với file picker
- ✅ ReadingView cơ bản
- ✅ ReaderSettingsView
- ✅ SettingsView

## 🚧 Cần hoàn thiện ngay

### 1. EPUB Parser - Ưu tiên cao nhất
**Vấn đề:** Cần thư viện ZIP để extract EPUB files

**Giải pháp:**
```swift
// Thêm vào Package.swift hoặc CocoaPods
dependencies: [
    .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.0")
]
```

**Cần làm:**
1. Thêm ZIPFoundation dependency
2. Update EPUBParser để sử dụng ZIPFoundation
3. Test với file EPUB thật

### 2. BookMetadata - Fix optional description
**Vấn đề:** `description` trong BookMetadata không optional nhưng có thể nil

**Cần sửa:**
```swift
struct BookMetadata {
    let description: String? // Thêm optional
    // ...
}
```

### 3. Import Progress - Fix ObservableObject
**Vấn đề:** BookManager cần @Published properties để UI update

**Cần sửa:**
```swift
class BookManager: ObservableObject {
    @Published var isImporting = false
    @Published var importProgress: Double = 0.0
    // ...
}
```

## 📋 Các tính năng tiếp theo (theo thứ tự ưu tiên)

### Phase 1: Core Reading (Tuần 1-2)

#### 1.1 Text Rendering Engine
- [ ] HTML to NSAttributedString conversion đầy đủ
- [ ] CSS parsing và application
- [ ] Image rendering trong text
- [ ] Table rendering
- [ ] Hyphenation support

**Files cần tạo:**
- `Core/TextRenderer/HTMLParser.swift`
- `Core/TextRenderer/CSSParser.swift`
- `Core/TextRenderer/ImageRenderer.swift`

#### 1.2 Page Calculation
- [ ] Calculate pages từ text content
- [ ] Page navigation logic
- [ ] Scroll position tracking

**Files cần tạo:**
- `Core/TextRenderer/PageCalculator.swift`

#### 1.3 Chapter Navigation
- [ ] Table of contents view
- [ ] Jump to chapter
- [ ] Chapter progress indicator

**Files cần update:**
- `Views/Reader/ChaptersView.swift` - hoàn thiện

### Phase 2: Reading Features (Tuần 3-4)

#### 2.1 Bookmark & Highlight
- [ ] Text selection
- [ ] Highlight với màu sắc
- [ ] Save/Edit/Delete bookmark
- [ ] Bookmark list view

**Files cần tạo:**
- `Views/Reader/HighlightView.swift`
- `Views/Reader/BookmarkListView.swift`
- `Core/TextRenderer/TextSelectionHandler.swift`

#### 2.2 Search
- [ ] Search trong sách
- [ ] Highlight search results
- [ ] Navigate between results

**Files cần tạo:**
- `Views/Reader/SearchView.swift`
- `Core/Search/BookSearchEngine.swift`

#### 2.3 Reading Settings
- [ ] Font picker với custom fonts
- [ ] Theme picker đầy đủ
- [ ] Margin adjustment
- [ ] Line spacing fine-tuning

**Files cần update:**
- `Views/Reader/ReaderSettingsView.swift` - mở rộng

### Phase 3: Advanced Features (Tuần 5-6)

#### 3.1 PDF Support
- [ ] PDF rendering với PDFKit
- [ ] PDF annotation
- [ ] PDF navigation

**Files cần tạo:**
- `Views/Reader/PDFReaderView.swift`
- `Core/Parsers/PDFAnnotationManager.swift`

#### 3.2 Cloud Sync
- [ ] iCloud Documents integration
- [ ] Dropbox SDK integration
- [ ] Sync bookmarks và reading progress

**Files cần tạo:**
- `Core/Sync/iCloudSync.swift`
- `Core/Sync/DropboxSync.swift`

#### 3.3 TTS
- [ ] AVSpeechSynthesizer integration
- [ ] Voice selection
- [ ] Speed control

**Files cần tạo:**
- `Core/TTS/TTSService.swift`
- `Views/Reader/TTSControlView.swift`

### Phase 4: Polish & Enhancements (Tuần 7-8)

#### 4.1 Statistics
- [ ] Reading time tracking
- [ ] Words read counter
- [ ] Reading calendar

**Files cần tạo:**
- `Views/Statistics/ReadingStatisticsView.swift`
- `Core/Statistics/ReadingTracker.swift`

#### 4.2 UI/UX
- [ ] Page flip animations
- [ ] Smooth scrolling
- [ ] Haptic feedback
- [ ] More themes

#### 4.3 OPDS Support
- [ ] OPDS client
- [ ] Browse online libraries
- [ ] Download from OPDS

## 🔧 Technical Debt

### Dependencies cần thêm
1. **ZIPFoundation** - cho EPUB parsing
   ```swift
   .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.0")
   ```

2. **AEXML** hoặc **XMLParser** - cho XML parsing (EPUB, FB2)
   - Có thể dùng Foundation XMLParser (built-in)

3. **Dropbox SDK** (nếu cần cloud sync)
   - Swift Package hoặc CocoaPods

### Code Quality
- [ ] Add unit tests cho parsers
- [ ] Add UI tests cho navigation
- [ ] Error handling đầy đủ
- [ ] Logging system

### Performance
- [ ] Lazy loading cho chapters
- [ ] Image caching
- [ ] Background parsing

## 📝 Notes

### EPUB Parser Implementation
EPUBParser hiện tại là placeholder. Cần:
1. Thêm ZIPFoundation
2. Implement ZipArchive class với ZIPFoundation
3. Test với nhiều EPUB files khác nhau

### Text Rendering
Hiện tại dùng SwiftUI Text - cần chuyển sang UIKit TextKit cho:
- Better HTML/CSS support
- Custom layout
- Hyphenation
- Image rendering

Có thể dùng `UIViewRepresentable` để wrap UITextView.

### Database
SQLite trực tiếp hiện tại OK, nhưng có thể migrate sang Core Data sau nếu cần:
- Better Swift integration
- Relationships
- Migration support

## 🎯 Mục tiêu ngắn hạn (1-2 tuần)

1. ✅ Hoàn thiện EPUB parser với ZIPFoundation
2. ✅ Implement text rendering engine cơ bản
3. ✅ Thêm bookmark/highlight functionality
4. ✅ Implement search trong sách
5. ✅ Test với nhiều loại sách khác nhau

## 📚 Tài liệu tham khảo

- Android code: `/Moon-Reader-Pro-v9.1.apk_Decompiler.com/sources/`
- EPUB spec: https://www.w3.org/publishing/epub3/
- SwiftUI docs: https://developer.apple.com/documentation/swiftui/
- PDFKit docs: https://developer.apple.com/documentation/pdfkit/

