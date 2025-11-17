# 📋 Kế Hoạch Chi Tiết Chuyển Đổi Sang React Native

## 🎯 Mục Tiêu
Chuyển đổi Moon Reader iOS (Swift/SwiftUI) sang React Native với Expo, test kỹ từng task.

## 📊 Tổng Quan Project

### Swift Files Cần Convert
- **Models**: 4 files (Book, Bookmark, Note, ReadingStatistics)
- **Core**: 20+ files (Database, Parsers, TextRenderer, Search, Statistics, TTS)
- **Views**: 20+ files (Library, Reader, Settings, Statistics)
- **Utilities**: 9 files
- **Total**: ~60+ files, ~7500+ lines

## 🗂️ Cấu Trúc Project React Native

```
MoonReaderRN/
├── app/                          # Expo Router
│   ├── (tabs)/
│   │   ├── library.tsx
│   │   ├── reader.tsx
│   │   └── settings.tsx
│   └── _layout.tsx
├── src/
│   ├── models/                   # TypeScript models
│   ├── database/                  # Database layer
│   ├── core/                      # Core functionality
│   ├── components/                # React components
│   ├── hooks/                     # Custom hooks
│   ├── services/                  # Services
│   ├── utils/                     # Utilities
│   └── store/                     # State management
├── assets/                        # Assets
├── __tests__/                     # Tests
├── app.json
├── package.json
└── tsconfig.json
```

## 📝 Chi Tiết Từng Task

---

## PHASE 1: SETUP & FOUNDATION

### Task 1.1: Setup Expo Project ⏱️ 30 phút
**Mục tiêu**: Tạo project React Native với Expo

**Steps**:
1. Tạo Expo project với TypeScript template
2. Setup folder structure
3. Install core dependencies
4. Setup TypeScript config
5. Setup ESLint & Prettier

**Dependencies cần install**:
```json
{
  "expo": "~50.0.0",
  "react": "18.2.0",
  "react-native": "0.73.0",
  "@react-navigation/native": "^6.1.0",
  "@react-navigation/bottom-tabs": "^6.5.0",
  "typescript": "^5.3.0"
}
```

**Test Cases**:
- [ ] Project tạo thành công
- [ ] `npm start` chạy được
- [ ] TypeScript compile không lỗi
- [ ] Folder structure đúng

**Acceptance Criteria**:
- ✅ Project structure đúng
- ✅ TypeScript config hoạt động
- ✅ Metro bundler chạy được

---

### Task 1.2: Setup Database (WatermelonDB) ⏱️ 1 giờ
**Mục tiêu**: Setup WatermelonDB với schema tương đương SQLite

**Steps**:
1. Install WatermelonDB
2. Define schema (Books, Bookmarks, Notes, Statistics)
3. Setup database instance
4. Create migrations
5. Test CRUD operations

**Schema cần tạo**:
- Books table
- Bookmarks table
- Notes table
- Statistics table

**Test Cases**:
- [ ] Database khởi tạo thành công
- [ ] Schema đúng với Swift version
- [ ] Insert book thành công
- [ ] Query books thành công
- [ ] Update book thành công
- [ ] Delete book thành công

**Acceptance Criteria**:
- ✅ Database schema match với Swift
- ✅ CRUD operations hoạt động
- ✅ Performance tốt (100+ books)

---

### Task 1.3: Convert Models sang TypeScript ⏱️ 1 giờ
**Mục tiêu**: Convert 4 models (Book, Bookmark, Note, ReadingStatistics)

**Files cần convert**:
1. `Models/Book.swift` → `src/models/Book.ts`
2. `Models/Bookmark.swift` → `src/models/Bookmark.ts`
3. `Models/Note.swift` → `src/models/Note.ts`
4. `Models/ReadingStatistics.swift` → `src/models/ReadingStatistics.ts`

**Test Cases cho mỗi model**:
- [ ] Type definition đúng
- [ ] Optional fields handle đúng
- [ ] Default values đúng
- [ ] Serialization/Deserialization hoạt động
- [ ] Type safety (TypeScript compile)

**Acceptance Criteria**:
- ✅ Tất cả models convert đúng
- ✅ TypeScript types chính xác
- ✅ Compatible với database schema

---

### Task 1.4: Setup Navigation ⏱️ 30 phút
**Mục tiêu**: Setup React Navigation với bottom tabs

**Steps**:
1. Install React Navigation
2. Setup Tab Navigator
3. Create 3 main screens (Library, Reader, Settings)
4. Setup navigation types

**Test Cases**:
- [ ] Navigation setup thành công
- [ ] 3 tabs hiển thị đúng
- [ ] Navigate giữa tabs hoạt động
- [ ] Navigation types đúng

**Acceptance Criteria**:
- ✅ Bottom tabs hoạt động
- ✅ Navigation types đúng
- ✅ UI match với SwiftUI version

---

## PHASE 2: CORE FEATURES

### Task 2.1: Implement Book Parsers ⏱️ 3 giờ
**Mục tiêu**: Convert book parsers (TXT, PDF, RTF, MD, EPUB)

**Parsers cần implement**:
1. TXTParser (priority 1)
2. MDParser (priority 1)
3. RTFParser (priority 2)
4. PDFParser (priority 2)
5. EPUBParser (priority 3)

**Test Cases cho mỗi parser**:
- [ ] Parse file thành công
- [ ] Extract metadata đúng
- [ ] Extract chapters đúng
- [ ] Handle encoding đúng (UTF-8, etc.)
- [ ] Handle large files (10MB+)
- [ ] Error handling tốt

**Test Files cần có**:
- Sample TXT file
- Sample MD file
- Sample RTF file
- Sample PDF file
- Sample EPUB file

**Acceptance Criteria**:
- ✅ TXT parser hoạt động 100%
- ✅ MD parser hoạt động 100%
- ✅ RTF parser hoạt động 80%+
- ✅ PDF parser hoạt động (basic)
- ✅ Error handling tốt

---

### Task 2.2: Implement Text Rendering ⏱️ 2 giờ
**Mục tiêu**: Render text với formatting, themes, fonts

**Components cần tạo**:
1. `TextRenderer.ts` - Core rendering logic
2. `PageCalculator.ts` - Calculate pages
3. `HTMLParser.ts` - Parse HTML content

**Features**:
- HTML to React Native Text
- Custom fonts
- Themes (Day/Night/AMOLED/Sepia)
- Text alignment
- Line spacing
- Margins

**Test Cases**:
- [ ] Render plain text đúng
- [ ] Render HTML đúng
- [ ] Apply fonts đúng
- [ ] Apply themes đúng
- [ ] Calculate pages đúng
- [ ] Performance tốt (smooth scrolling)

**Acceptance Criteria**:
- ✅ Text rendering match SwiftUI version
- ✅ Performance tốt
- ✅ All themes hoạt động

---

### Task 2.3: Build Library View ⏱️ 2 giờ
**Mục tiêu**: Create BookShelfView với Grid/List view

**Components**:
1. `BookShelfView.tsx` - Main library view
2. `BookCard.tsx` - Book card component
3. `BookDetailView.tsx` - Book details
4. `ImportBookButton.tsx` - Import functionality

**Features**:
- Grid view (3 columns)
- List view
- Search trong library
- Book details
- Import sách
- Delete sách
- Favorite/Unfavorite

**Test Cases**:
- [ ] Display books đúng
- [ ] Grid/List view switch hoạt động
- [ ] Search hoạt động
- [ ] Import sách thành công
- [ ] Delete sách thành công
- [ ] Favorite toggle hoạt động
- [ ] Book details hiển thị đúng

**Acceptance Criteria**:
- ✅ UI match SwiftUI version
- ✅ Tất cả features hoạt động
- ✅ Performance tốt với 100+ books

---

### Task 2.4: Build Reading View ⏱️ 3 giờ
**Mục tiêu**: Create ReadingView với page navigation

**Components**:
1. `ReadingView.tsx` - Main reading view
2. `ReaderSettingsView.tsx` - Settings overlay
3. `ReadingProgressView.tsx` - Progress indicator

**Features**:
- Load và display sách
- Page navigation (swipe, buttons)
- Chapter navigation
- Reading position tracking
- Auto-save position
- Settings overlay
- Progress indicators

**Test Cases**:
- [ ] Load sách thành công
- [ ] Display text đúng
- [ ] Page navigation hoạt động
- [ ] Chapter navigation hoạt động
- [ ] Reading position save/restore đúng
- [ ] Settings apply ngay lập tức
- [ ] Performance smooth

**Acceptance Criteria**:
- ✅ Reading experience match SwiftUI version
- ✅ Navigation smooth
- ✅ Position tracking chính xác

---

## PHASE 3: ADVANCED FEATURES

### Task 3.1: Implement Bookmark & Highlight ⏱️ 2 giờ
**Mục tiêu**: Bookmark và highlight system

**Components**:
1. `BookmarkListView.tsx` - List bookmarks
2. `HighlightMenuView.tsx` - Highlight menu
3. Text selection handler

**Features**:
- Text selection (long press)
- 6 màu highlight
- Create/Edit/Delete bookmarks
- Add notes to bookmarks
- Navigate to bookmark

**Test Cases**:
- [ ] Text selection hoạt động
- [ ] Highlight với 6 màu
- [ ] Create bookmark thành công
- [ ] Edit bookmark thành công
- [ ] Delete bookmark thành công
- [ ] Navigate to bookmark đúng
- [ ] Notes save/load đúng

**Acceptance Criteria**:
- ✅ Bookmark system hoạt động 100%
- ✅ Highlight colors đúng
- ✅ Notes functionality hoạt động

---

### Task 3.2: Implement Search ⏱️ 1.5 giờ
**Mục tiêu**: Search trong sách và library

**Components**:
1. `SearchView.tsx` - Search interface
2. `BookSearchEngine.ts` - Search logic

**Features**:
- Search trong sách
- Highlight search results
- Navigate to results
- Search trong library

**Test Cases**:
- [ ] Search trong sách hoạt động
- [ ] Highlight results đúng
- [ ] Navigate to results đúng
- [ ] Search trong library hoạt động
- [ ] Performance tốt với large books

**Acceptance Criteria**:
- ✅ Search hoạt động chính xác
- ✅ Performance tốt
- ✅ UI intuitive

---

### Task 3.3: Implement Settings & Themes ⏱️ 1.5 giờ
**Mục tiêu**: Settings và theme system

**Components**:
1. `SettingsView.tsx` - Main settings
2. `FontPickerView.tsx` - Font picker
3. `ThemeManager.ts` - Theme logic

**Features**:
- 8 fonts selection
- Font size (12-32pt)
- Line spacing (0-20pt)
- 4 themes (Day/Night/AMOLED/Sepia)
- Margins (10-50pt)
- Text alignment (4 options)
- Settings persist

**Test Cases**:
- [ ] Font selection hoạt động
- [ ] Font size change đúng
- [ ] Line spacing change đúng
- [ ] Theme switch hoạt động
- [ ] Margins change đúng
- [ ] Text alignment hoạt động
- [ ] Settings persist sau restart

**Acceptance Criteria**:
- ✅ Tất cả settings hoạt động
- ✅ Settings persist đúng
- ✅ UI match SwiftUI version

---

### Task 3.4: Implement Statistics ⏱️ 2 giờ
**Mục tiêu**: Reading statistics và calendar

**Components**:
1. `ReadingStatisticsView.tsx` - Statistics view
2. `ReadingCalendarView.tsx` - Calendar view
3. `ReadingTracker.ts` - Tracking logic

**Features**:
- Reading time tracking
- Words read counter
- Daily/Weekly/Monthly/Yearly stats
- Reading calendar
- Book statistics
- Average reading speed

**Test Cases**:
- [ ] Reading time track đúng
- [ ] Words count đúng
- [ ] Daily stats hiển thị đúng
- [ ] Weekly/Monthly/Yearly stats đúng
- [ ] Calendar hiển thị đúng
- [ ] Book stats đúng
- [ ] Average speed tính đúng

**Acceptance Criteria**:
- ✅ Statistics tracking chính xác
- ✅ Calendar hoạt động
- ✅ UI match SwiftUI version

---

### Task 3.5: Implement TTS ⏱️ 1 giờ
**Mục tiêu**: Text-to-Speech functionality

**Components**:
1. `TTSControlView.tsx` - TTS controls
2. `TTSService.ts` - TTS logic

**Features**:
- expo-speech integration
- Voice selection (Vietnamese + others)
- Speed control
- Play/Pause/Stop

**Test Cases**:
- [ ] TTS speak đúng
- [ ] Voice selection hoạt động
- [ ] Speed control hoạt động
- [ ] Play/Pause/Stop hoạt động
- [ ] Vietnamese voice available

**Acceptance Criteria**:
- ✅ TTS hoạt động 100%
- ✅ Vietnamese voice hoạt động
- ✅ Controls intuitive

---

## PHASE 4: POLISH & TESTING

### Task 4.1: Implement PDF Support ⏱️ 1.5 giờ
**Mục tiêu**: PDF reading với react-native-pdf

**Components**:
1. `PDFReaderView.tsx` - PDF reader

**Features**:
- PDF rendering
- Page navigation
- Zoom in/out
- PDF annotations view

**Test Cases**:
- [ ] PDF load thành công
- [ ] Page navigation hoạt động
- [ ] Zoom hoạt động
- [ ] Annotations hiển thị
- [ ] Performance tốt

**Acceptance Criteria**:
- ✅ PDF reading hoạt động
- ✅ Performance acceptable

---

### Task 4.2: Setup Cloud Sync (Optional) ⏱️ 2 giờ
**Mục tiêu**: Cloud sync với Firebase hoặc Supabase

**Components**:
1. `CloudSyncView.tsx` - Cloud sync UI
2. `cloudSync.ts` - Sync logic

**Features**:
- Firebase/Supabase integration
- Sync books
- Sync bookmarks
- Sync reading position

**Test Cases**:
- [ ] Login/Logout hoạt động
- [ ] Sync books thành công
- [ ] Sync bookmarks thành công
- [ ] Sync position thành công
- [ ] Conflict resolution

**Acceptance Criteria**:
- ✅ Cloud sync hoạt động
- ✅ Data consistency

---

### Task 4.3: Testing & Bug Fixes ⏱️ 3 giờ
**Mục tiêu**: Test toàn bộ app và fix bugs

**Test Areas**:
1. Unit tests cho core logic
2. Integration tests cho features
3. UI tests cho components
4. Performance testing
5. Memory leak testing

**Test Checklist**:
- [ ] All features hoạt động
- [ ] No crashes
- [ ] Performance tốt
- [ ] No memory leaks
- [ ] Error handling tốt
- [ ] UI/UX tốt

**Acceptance Criteria**:
- ✅ Tất cả tests pass
- ✅ No critical bugs
- ✅ Performance acceptable

---

### Task 4.4: Performance Optimization ⏱️ 2 giờ
**Mục tiêu**: Optimize performance

**Optimizations**:
1. React.memo cho components
2. useMemo, useCallback
3. FlatList optimization
4. Image optimization
5. Lazy loading
6. Code splitting

**Test Cases**:
- [ ] App start nhanh (< 2s)
- [ ] Smooth scrolling
- [ ] No lag khi navigate
- [ ] Memory usage acceptable
- [ ] Battery usage acceptable

**Acceptance Criteria**:
- ✅ Performance tốt
- ✅ No lag
- ✅ Memory efficient

---

## 📊 Timeline Tổng Quan

| Phase | Tasks | Estimated Time | Status |
|-------|-------|----------------|--------|
| Phase 1 | 4 tasks | 3 giờ | ⏳ Pending |
| Phase 2 | 4 tasks | 10 giờ | ⏳ Pending |
| Phase 3 | 5 tasks | 8 giờ | ⏳ Pending |
| Phase 4 | 4 tasks | 8.5 giờ | ⏳ Pending |
| **Total** | **17 tasks** | **~30 giờ** | ⏳ Pending |

## 🧪 Testing Strategy

### Unit Tests
- Test core logic (parsers, renderers, etc.)
- Test utilities
- Test hooks

### Integration Tests
- Test features end-to-end
- Test database operations
- Test navigation

### UI Tests
- Test components render đúng
- Test user interactions
- Test responsive design

### Performance Tests
- Test với large datasets
- Test memory usage
- Test battery usage

## ✅ Definition of Done

Mỗi task được coi là DONE khi:
1. ✅ Code implement đầy đủ
2. ✅ Tất cả test cases pass
3. ✅ No TypeScript errors
4. ✅ No ESLint errors
5. ✅ Code reviewed (self-review)
6. ✅ Documentation updated
7. ✅ Performance acceptable

## 🚀 Bắt Đầu Implementation

Sẽ bắt đầu với Task 1.1: Setup Expo Project

