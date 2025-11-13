# Moon Reader iOS

Ứng dụng đọc sách Moon Reader cho iOS, được port từ phiên bản Android với đầy đủ tính năng.

## ✅ Tính năng đã hoàn thành

### 📚 Quản lý sách
- ✅ Import sách từ Files app (TXT, PDF, RTF, MD, EPUB structure)
- ✅ Parse metadata và chapters
- ✅ Thư viện sách với Grid/List/CoverFlow view
- ✅ Search trong thư viện
- ✅ Book details với actions
- ✅ Favorite và Rating

### 📖 Đọc sách
- ✅ Load và parse sách
- ✅ Display chapters và pages
- ✅ Page navigation (swipe gestures, buttons)
- ✅ Chapter navigation với mục lục
- ✅ Reading position tracking và auto-save
- ✅ PDF support với PDFKit
- ✅ Progress indicators (page & chapter)

### 🎨 Tùy chỉnh
- ✅ 8 fonts selection
- ✅ Font size (12-32pt)
- ✅ Line spacing (0-20pt)
- ✅ 4 themes (Day/Night/AMOLED/Sepia)
- ✅ Margins (10-50pt)
- ✅ Text alignment (4 options)
- ✅ Settings apply immediately

### 🔖 Bookmarks & Highlights
- ✅ Text selection (long press)
- ✅ 6 màu highlight
- ✅ Create/Edit/Delete bookmarks
- ✅ Add notes to bookmarks
- ✅ Bookmark list view
- ✅ Navigate to bookmark

### 🔍 Search & Navigation
- ✅ Search trong sách
- ✅ Highlight search results
- ✅ Navigate to results
- ✅ Chapter list với preview
- ✅ Jump to chapter

### 📊 Statistics
- ✅ Reading time tracking
- ✅ Words read counter
- ✅ Daily/Weekly/Monthly/Yearly statistics
- ✅ Reading calendar
- ✅ Book statistics
- ✅ Average reading speed

### 🔊 TTS (Text-to-Speech)
- ✅ AVSpeechSynthesizer integration
- ✅ Voice selection (Vietnamese + others)
- ✅ Speed control
- ✅ Play/Pause/Stop

### 📄 PDF Support
- ✅ PDFKit rendering
- ✅ Page navigation
- ✅ PDF annotations view

### 📱 UI/UX
- ✅ Modern SwiftUI interface
- ✅ Progress indicators
- ✅ Loading states
- ✅ Error handling
- ✅ Empty states
- ✅ Smooth animations

## 🚧 Tính năng đang phát triển

- ☁️ Cloud Sync (iCloud, Dropbox, WebDAV)
- 📡 OPDS Support
- 🧪 Testing & Polish

## Cấu trúc Project

```
MoonReader/
├── MoonReaderApp.swift              # Entry point
├── Models/                          # Data models
│   ├── Book.swift
│   ├── Bookmark.swift
│   ├── Note.swift
│   └── ReadingStatistics.swift
├── Core/                            # Core functionality
│   ├── Database/
│   │   └── BookDatabase.swift      # SQLite manager
│   ├── BookContentManager.swift    # Content management
│   ├── BookManager.swift           # Import manager
│   ├── Parsers/                    # Book format parsers
│   │   ├── BaseBookParser.swift
│   │   ├── EPUBParser.swift
│   │   ├── TXTParser.swift
│   │   ├── PDFParser.swift
│   │   └── ... (10 parsers)
│   ├── TextRenderer/               # Text rendering
│   │   ├── HTMLParser.swift
│   │   ├── PageCalculator.swift
│   │   ├── EnhancedTextRenderer.swift
│   │   └── BookTextRenderer.swift
│   ├── Search/
│   │   └── BookSearchEngine.swift
│   ├── Statistics/
│   │   └── ReadingTracker.swift
│   ├── TTS/
│   │   └── TTSService.swift
│   └── AutoScroll/
│       └── AutoScrollManager.swift
├── Views/                           # SwiftUI Views
│   ├── Library/
│   │   ├── BookShelfView.swift
│   │   ├── BookDetailView.swift
│   │   └── ImportBookButton.swift
│   ├── Reader/
│   │   ├── ReadingView.swift
│   │   ├── ReaderSettingsView.swift
│   │   ├── BookmarkListView.swift
│   │   ├── SearchView.swift
│   │   ├── HighlightMenuView.swift
│   │   ├── TTSControlView.swift
│   │   ├── PDFReaderView.swift
│   │   ├── ReadingProgressView.swift
│   │   ├── FontPickerView.swift
│   │   └── DictionaryView.swift
│   ├── Statistics/
│   │   ├── ReadingStatisticsView.swift
│   │   └── ReadingCalendarView.swift
│   └── Settings/
│       └── SettingsView.swift
├── ViewModels/                      # ViewModels
│   └── ReaderViewModel.swift
└── Utilities/                       # Helper classes
    ├── ThemeManager.swift
    ├── GestureHandler.swift
    └── PerformanceOptimizer.swift
```

## Yêu cầu

- iOS 15.0+ (một số tính năng cần iOS 16.0+)
- Xcode 14.0+
- Swift 5.7+

## Cài đặt

1. Mở project trong Xcode:
   ```bash
   cd /home/camph/Documents/MoonReader/NewApp
   open MoonReader.xcodeproj
   ```

2. Thêm dependencies (nếu cần):
   - ZIPFoundation cho EPUB parsing (optional)
   - Dropbox SDK cho cloud sync (optional)

3. Chọn target device/simulator

4. Build và run

## Sử dụng

1. **Import sách**: Nhấn nút + trong thư viện → Chọn file sách
2. **Đọc sách**: Tap vào sách → Bắt đầu đọc
3. **Highlight**: Long press text → Chọn màu highlight
4. **Bookmark**: Từ highlight menu → Add note
5. **Search**: Tap icon search → Nhập từ khóa
6. **Settings**: Tap icon settings → Tùy chỉnh

## Progress

**Completed: 13/18 tasks (72%)**

### ✅ Core Features: 100%
- Database & Models
- Book Parsers
- UI Components
- Import System
- Text Rendering
- Bookmark & Highlight
- Search
- Settings & Themes
- Chapter Navigation
- Reading Position
- Performance Optimization
- Statistics & Calendar
- TTS
- PDF Support

### 🚧 Advanced Features: 0%
- Cloud Sync
- OPDS Support
- Testing & Polish

## Tài liệu

- `FEATURES_COMPLETE.md` - Danh sách tính năng đã hoàn thành
- `FINAL_SUMMARY.md` - Tóm tắt cuối cùng
- `NEXT_STEPS.md` - Hướng dẫn tiếp theo
- `PROJECT_STATUS.md` - Trạng thái project

## 🚀 Quick Start

### Mở Project
```bash
cd /home/camph/Documents/MoonReader/NewApp
open MoonReader.xcodeproj
```

Hoặc chạy script:
```bash
./OPEN_PROJECT.sh
```

### Build & Run
1. Chọn Simulator (iPhone 15 Pro)
2. Press `Command + R` để run
3. App sẽ chạy trên Simulator

### Test trên Simulator
Xem `TESTING_GUIDE.md` để biết cách test chi tiết các tính năng.

### Build cho iPhone thật
Xem `BUILD_FOR_DEVICE.md` để biết cách build và cài app lên iPhone.

## 📚 Documentation

- `TESTING_GUIDE.md` - Hướng dẫn test chi tiết
- `BUILD_FOR_DEVICE.md` - Build và cài lên iPhone
- `BUILD_QUICK.md` - Quick build guide
- `CODEMAGIC_SETUP.md` - CI/CD với Codemagic
- `QUICK_START.md` - Quick start guide
- `FEATURES_COMPLETE.md` - Danh sách tính năng
- `PROJECT_FINAL.md` - Tổng kết project

## Lưu ý

- EPUB Parser cần ZIPFoundation để parse EPUB thực sự (hiện tại chỉ có structure)
- Một số tính năng advanced (Cloud Sync, OPDS) cần network connection để test
- App đã sẵn sàng để test với các file sách thực (TXT, PDF, RTF, MD)

# moon-reader-ios
