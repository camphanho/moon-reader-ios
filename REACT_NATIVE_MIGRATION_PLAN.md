# 🚀 Kế Hoạch Chuyển Đổi Sang React Native

## 📋 Tổng Quan

Chuyển đổi Moon Reader iOS (Swift/SwiftUI) sang React Native để:
- ✅ Develop trên Linux/Windows (không cần Mac)
- ✅ Cross-platform (iOS + Android)
- ✅ Build iOS trên cloud services
- ✅ Test trên Android emulator

## 🎯 Lựa Chọn Framework

### Option 1: Expo (RECOMMENDED) ⭐
**Ưu điểm:**
- Setup nhanh, dễ dàng
- EAS Build cho iOS (không cần Mac)
- Nhiều libraries có sẵn
- Over-the-air updates

**Nhược điểm:**
- Một số native modules cần custom development
- Bundle size lớn hơn một chút

### Option 2: React Native CLI
**Ưu điểm:**
- Full control
- Tối ưu bundle size
- Native modules dễ integrate

**Nhược điểm:**
- Setup phức tạp hơn
- Cần config nhiều hơn

**Recommendation: Expo** (dễ nhất cho case này)

## 📦 Tech Stack Đề Xuất

### Core
- **React Native**: 0.73+
- **Expo**: SDK 50+
- **TypeScript**: Type safety
- **React Navigation**: Navigation

### Database
- **WatermelonDB**: High-performance database (RECOMMENDED)
- Hoặc **react-native-sqlite-storage**: Đơn giản hơn

### File Management
- **expo-file-system**: File operations
- **expo-document-picker**: Import sách
- **react-native-fs**: Advanced file operations

### PDF Support
- **react-native-pdf**: PDF rendering
- Hoặc **react-native-view-pdf**: Alternative

### TTS (Text-to-Speech)
- **expo-speech**: Expo built-in
- Hoặc **react-native-tts**: More features

### UI Components
- **react-native-reanimated**: Animations
- **react-native-gesture-handler**: Gestures
- **react-native-svg**: Icons và graphics
- **react-native-paper** hoặc **NativeBase**: UI components

### Cloud Sync
- **Firebase**: Backend service
- Hoặc **Supabase**: Alternative
- Hoặc **Custom Backend**: Full control

### State Management
- **Zustand**: Lightweight (RECOMMENDED)
- Hoặc **Redux Toolkit**: Nếu cần complex state

## 🗂️ Cấu Trúc Project Mới

```
MoonReaderRN/
├── app/                          # Expo Router (nếu dùng)
│   ├── (tabs)/
│   │   ├── library.tsx
│   │   ├── reader.tsx
│   │   └── settings.tsx
│   └── _layout.tsx
├── src/
│   ├── models/                   # TypeScript models
│   │   ├── Book.ts
│   │   ├── Bookmark.ts
│   │   ├── Note.ts
│   │   └── ReadingStatistics.ts
│   ├── database/                 # Database layer
│   │   ├── schema.ts
│   │   └── database.ts
│   ├── core/                     # Core functionality
│   │   ├── parsers/              # Book parsers
│   │   │   ├── TXTParser.ts
│   │   │   ├── PDFParser.ts
│   │   │   ├── EPUBParser.ts
│   │   │   └── ...
│   │   ├── textRenderer/         # Text rendering
│   │   │   ├── PageCalculator.ts
│   │   │   └── TextRenderer.ts
│   │   ├── search/               # Search engine
│   │   │   └── BookSearchEngine.ts
│   │   ├── statistics/          # Statistics tracking
│   │   │   └── ReadingTracker.ts
│   │   └── tts/                  # TTS service
│   │       └── TTSService.ts
│   ├── components/               # React components
│   │   ├── library/
│   │   │   ├── BookShelfView.tsx
│   │   │   ├── BookDetailView.tsx
│   │   │   └── ImportBookButton.tsx
│   │   ├── reader/
│   │   │   ├── ReadingView.tsx
│   │   │   ├── ReaderSettingsView.tsx
│   │   │   ├── BookmarkListView.tsx
│   │   │   ├── SearchView.tsx
│   │   │   └── PDFReaderView.tsx
│   │   ├── statistics/
│   │   │   ├── ReadingStatisticsView.tsx
│   │   │   └── ReadingCalendarView.tsx
│   │   └── common/
│   │       ├── LoadingView.tsx
│   │       └── ErrorView.tsx
│   ├── hooks/                    # Custom hooks
│   │   ├── useBook.ts
│   │   ├── useReader.ts
│   │   └── useStatistics.ts
│   ├── services/                 # Services
│   │   ├── cloudSync.ts
│   │   └── opds.ts
│   ├── utils/                    # Utilities
│   │   ├── theme.ts
│   │   ├── constants.ts
│   │   └── helpers.ts
│   └── store/                    # State management
│       └── bookStore.ts
├── assets/                       # Assets
│   ├── fonts/
│   └── images/
├── app.json                      # Expo config
├── package.json
└── tsconfig.json
```

## 🔄 Migration Steps

### Phase 1: Setup & Foundation (1-2 ngày)
1. ✅ Tạo Expo project
2. ✅ Setup TypeScript
3. ✅ Setup navigation
4. ✅ Setup database (WatermelonDB)
5. ✅ Convert Models sang TypeScript

### Phase 2: Core Features (3-5 ngày)
1. ✅ Implement Book Parsers (TXT, PDF, RTF, MD)
2. ✅ Implement Text Rendering
3. ✅ Implement Page Calculation
4. ✅ Build Library View
5. ✅ Build Reading View

### Phase 3: Advanced Features (3-5 ngày)
1. ✅ Implement Bookmark & Highlight
2. ✅ Implement Search
3. ✅ Implement Settings & Themes
4. ✅ Implement Statistics
5. ✅ Implement TTS

### Phase 4: Polish & Testing (2-3 ngày)
1. ✅ PDF Support
2. ✅ Cloud Sync
3. ✅ OPDS Support
4. ✅ Testing
5. ✅ Performance optimization

**Total: ~10-15 ngày**

## 🔧 Mapping Swift → React Native

### Models
```swift
// Swift
struct Book: Identifiable, Codable {
    var id: UUID
    var title: String
    ...
}
```

```typescript
// TypeScript
interface Book {
  id: string;
  title: string;
  ...
}
```

### Database
```swift
// Swift - SQLite với BookDatabase
let db = BookDatabase.shared
db.addBook(book)
```

```typescript
// TypeScript - WatermelonDB
import { database } from './database';
await database.write(async () => {
  await database.collections.get('books').create(book);
});
```

### Text Rendering
```swift
// Swift - UITextView với NSAttributedString
Text(attributedString)
```

```typescript
// React Native - Text component với nested Text
<Text>
  <Text style={styles.highlight}>Highlighted</Text>
  <Text>Normal text</Text>
</Text>
```

### PDF Support
```swift
// Swift - PDFKit
PDFView(document: pdfDocument)
```

```typescript
// React Native - react-native-pdf
import Pdf from 'react-native-pdf';
<Pdf source={pdfSource} />
```

### TTS
```swift
// Swift - AVSpeechSynthesizer
let synthesizer = AVSpeechSynthesizer()
synthesizer.speak(utterance)
```

```typescript
// React Native - expo-speech
import * as Speech from 'expo-speech';
Speech.speak(text, { language: 'vi-VN' });
```

## 📱 Testing Strategy

### Android (Local)
```bash
# Start Metro bundler
npm start

# Run on Android emulator
npm run android
```

### iOS (Cloud Build)
```bash
# Setup EAS Build
npm install -g eas-cli
eas login
eas build:configure

# Build for iOS
eas build --platform ios
```

## 🚀 Quick Start Commands

### Setup Project
```bash
# Tạo Expo project
npx create-expo-app MoonReaderRN --template

# Install dependencies
cd MoonReaderRN
npm install

# Install specific packages
npm install watermelon-db
npm install react-native-pdf
npm install expo-speech
npm install @react-navigation/native
npm install react-native-reanimated
```

### Development
```bash
# Start development server
npm start

# Run on Android
npm run android

# Run on iOS (nếu có Mac)
npm run ios
```

### Build
```bash
# Build Android APK
eas build --platform android

# Build iOS (cloud)
eas build --platform ios
```

## ⚠️ Lưu Ý Quan Trọng

### 1. Performance
- React Native có thể chậm hơn native một chút
- Cần optimize với:
  - React.memo
  - useMemo, useCallback
  - FlatList cho long lists
  - Lazy loading

### 2. File Formats
- EPUB parsing: Cần library như `epubjs` hoặc `epub.js`
- PDF: `react-native-pdf` hoạt động tốt
- TXT, RTF, MD: Dễ implement với JavaScript

### 3. Native Modules
- Một số tính năng cần native modules
- Có thể viết custom native modules nếu cần

### 4. Testing
- Test trên Android emulator trước
- iOS testing: Dùng EAS Build hoặc Codemagic
- Test trên device thật khi có thể

## 📊 So Sánh

| Aspect | Swift/SwiftUI | React Native |
|--------|---------------|--------------|
| **Development** | Cần Mac | Linux/Windows OK |
| **Platform** | iOS only | iOS + Android |
| **Performance** | Native speed | Gần native |
| **Build iOS** | Cần Mac | Cloud build OK |
| **Learning Curve** | Swift | JavaScript/TypeScript |
| **Ecosystem** | iOS only | Cross-platform |

## ✅ Kết Luận

**Chuyển sang React Native là QUYẾT ĐỊNH ĐÚNG** vì:
1. ✅ Không cần Mac để develop
2. ✅ Cross-platform (iOS + Android)
3. ✅ Build iOS trên cloud
4. ✅ Test trên Android emulator
5. ✅ Hệ sinh thái phong phú

**Recommendation: Bắt đầu với Expo, migrate từng phần một.**

## 🎯 Next Steps

1. ✅ Quyết định: Expo hay React Native CLI
2. ✅ Setup project mới
3. ✅ Convert Models đầu tiên
4. ✅ Implement từng feature một
5. ✅ Test trên Android
6. ✅ Build iOS trên cloud

**Bạn có muốn tôi bắt đầu setup project React Native ngay không?** 🚀

