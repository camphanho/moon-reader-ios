# Trạng thái dự án Moon Reader iOS

## ✅ Đã hoàn thành

### 1. Cấu trúc Project
- ✅ Tạo cấu trúc thư mục theo chuẩn iOS
- ✅ Setup Xcode project cơ bản
- ✅ Tổ chức code theo MVVM pattern

### 2. Models & Database
- ✅ Book model với đầy đủ thuộc tính
- ✅ Bookmark model
- ✅ Note model
- ✅ ReadingStatistics model
- ✅ BookDatabase với SQLite (tương đương BookDb.java)
- ✅ Hỗ trợ CRUD operations cho books và bookmarks

### 3. UI Components
- ✅ BookShelfView - hiển thị thư viện sách (grid/list/cover flow)
- ✅ BookCard - card hiển thị sách
- ✅ BookDetailView - chi tiết sách
- ✅ ReadingView - màn hình đọc sách cơ bản
- ✅ ReaderSettingsView - cài đặt đọc
- ✅ SettingsView - màn hình cài đặt chính
- ✅ SearchBar component

### 4. Utilities
- ✅ ThemeManager - quản lý themes
- ✅ BookTextRenderer - render text cơ bản
- ✅ GestureHandler - xử lý gestures

### 5. Parsers (Cơ bản)
- ✅ BaseBookParser protocol
- ✅ TXTParser - parser cho file TXT
- ✅ EPUBParser - structure cơ bản

## 🚧 Đang làm

### Reading View
- Đang implement text rendering engine
- Cần hoàn thiện page turning logic
- Cần implement chapter navigation

## 📋 Cần làm tiếp

### 1. Book Parsers (Ưu tiên cao)
- [ ] EPUBParser - hoàn thiện parse EPUB files
- [ ] FB2Parser - parse FB2 format
- [ ] MOBIParser - parse MOBI/AZW format
- [ ] PDFParser - parse và render PDF
- [ ] DOCXParser - parse DOCX files
- [ ] RTFParser - parse RTF files
- [ ] CHMParser - parse CHM files
- [ ] MDParser - parse Markdown files
- [ ] ComicParser - parse CBZ/CBR files

### 2. Text Rendering Engine (Ưu tiên cao)
- [ ] HTML/CSS parsing đầy đủ
- [ ] Hyphenation support
- [ ] Custom text layout với line breaks
- [ ] Image rendering trong text
- [ ] Table rendering
- [ ] Footnote support

### 3. Reading Features
- [ ] Page turning animations
- [ ] Scroll mode
- [ ] Dual page mode
- [ ] Auto-scroll mode
- [ ] Brightness control bằng gesture
- [ ] Font picker với custom fonts
- [ ] Text selection và highlight
- [ ] Dictionary lookup
- [ ] Translation support

### 4. Bookmark & Notes
- [ ] Highlight text với màu sắc
- [ ] Add/Edit/Delete bookmarks
- [ ] Add/Edit/Delete notes
- [ ] Share highlighted text
- [ ] Export notes

### 5. Search & Navigation
- [ ] Search trong sách
- [ ] Chapter navigation
- [ ] Table of contents
- [ ] Jump to page
- [ ] Reading progress indicator

### 6. Cloud Sync
- [ ] iCloud integration
- [ ] Dropbox SDK integration
- [ ] WebDAV support
- [ ] Sync bookmarks và notes
- [ ] Sync reading progress

### 7. Statistics & Calendar
- [ ] Reading statistics tracking
- [ ] Daily reading time
- [ ] Reading calendar
- [ ] Words read counter
- [ ] Reading speed calculation

### 8. TTS (Text-to-Speech)
- [ ] AVSpeechSynthesizer integration
- [ ] Voice selection
- [ ] Speed control
- [ ] Pause/Resume
- [ ] Background playback

### 9. UI/UX Enhancements
- [ ] More theme options
- [ ] Custom theme creator
- [ ] Page flip animations (5 styles như Android)
- [ ] Cover flow animation
- [ ] Smooth scrolling
- [ ] Haptic feedback

### 10. PDF Support
- [ ] PDF rendering với PDFKit
- [ ] PDF annotation
- [ ] PDF text extraction
- [ ] PDF navigation

### 11. OPDS Support
- [ ] OPDS client
- [ ] Browse online libraries
- [ ] Download from OPDS
- [ ] Search OPDS catalogs

### 12. Advanced Features
- [ ] Book grouping
- [ ] Collections
- [ ] Tags
- [ ] Reading goals
- [ ] Export/Import settings
- [ ] Backup/Restore

## 📝 Ghi chú

### Dependencies cần thêm
- ZipArchive hoặc ZIPFoundation cho EPUB parsing
- PDFKit (built-in) cho PDF
- AVFoundation cho TTS
- Dropbox SDK cho cloud sync

### Architecture
- Sử dụng SwiftUI cho UI
- SQLite trực tiếp (có thể chuyển sang Core Data sau)
- MVVM pattern
- Protocol-oriented programming cho parsers

### Tương đương với Android code
- `BookDatabase.swift` ≈ `BookDb.java`
- `BookShelfView.swift` ≈ `ActivityMain.java` + `BookShelfView.java`
- `ReadingView.swift` ≈ `ActivityTxt.java` + `MRBookView.java`
- `BaseBookParser.swift` ≈ `BaseEBook.java`
- `BookTextRenderer.swift` ≈ `staticlayout` package
- `ThemeManager.swift` ≈ `PrefTheme.java` + theme XML files

## 🎯 Mục tiêu tiếp theo

1. Hoàn thiện EPUB parser để có thể đọc được sách EPUB
2. Implement text rendering engine đầy đủ
3. Thêm bookmark và highlight functionality
4. Implement search trong sách
5. Thêm cloud sync cơ bản

