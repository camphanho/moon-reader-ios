# Moon Reader React Native

Ứng dụng đọc sách Moon Reader cho iOS và Android, được chuyển đổi từ phiên bản Swift/SwiftUI.

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- npm hoặc yarn
- Android Studio (cho Android development)
- Expo Go app (cho testing trên device)

### Installation

```bash
# Install dependencies
npm install

# Start Metro bundler
npm start

# Run on Android
npm run android

# Run on iOS (cần Mac)
npm run ios

# Run on Web
npm run web
```

## 📁 Project Structure

```
MoonReaderRN/
├── app/                    # Expo Router (nếu dùng)
├── src/
│   ├── models/            # TypeScript models
│   ├── database/          # Database layer (WatermelonDB)
│   ├── core/              # Core functionality
│   │   ├── parsers/       # Book parsers
│   │   ├── textRenderer/  # Text rendering
│   │   ├── search/       # Search engine
│   │   ├── statistics/   # Statistics tracking
│   │   └── tts/          # TTS service
│   ├── components/        # React components
│   │   ├── library/      # Library views
│   │   ├── reader/       # Reader views
│   │   ├── statistics/   # Statistics views
│   │   ├── settings/    # Settings views
│   │   └── common/      # Common components
│   ├── hooks/            # Custom hooks
│   ├── services/         # Services
│   ├── utils/            # Utilities
│   └── store/            # State management (Zustand)
├── assets/               # Assets (fonts, images)
└── __tests__/            # Tests
```

## 🛠️ Tech Stack

- **React Native**: 0.81.5
- **Expo**: ~54.0.23
- **TypeScript**: ~5.9.2
- **React Navigation**: Navigation
- **WatermelonDB**: Database
- **Zustand**: State management
- **expo-speech**: TTS
- **react-native-pdf**: PDF support

## 📋 Features

### ✅ Completed
- [x] Project setup
- [x] Folder structure
- [x] TypeScript configuration
- [x] Dependencies installation

### 🚧 In Progress
- [ ] Database setup (WatermelonDB)
- [ ] Models conversion
- [ ] Navigation setup

### 📝 Planned
- [ ] Book parsers
- [ ] Text rendering
- [ ] Library view
- [ ] Reading view
- [ ] Bookmarks & Highlights
- [ ] Search
- [ ] Settings & Themes
- [ ] Statistics
- [ ] TTS
- [ ] PDF support

## 🧪 Testing

```bash
# Run tests
npm test

# Run with coverage
npm test -- --coverage
```

## 📱 Build

### Android
```bash
# Build APK
eas build --platform android

# Build AAB
eas build --platform android --profile production
```

### iOS
```bash
# Build IPA (cloud build)
eas build --platform ios
```

## 📚 Documentation

Xem `DETAILED_MIGRATION_PLAN.md` để biết kế hoạch chi tiết migration.

## 🐛 Known Issues

- WatermelonDB có conflict với React 19 types (đã fix với --legacy-peer-deps)

## 📄 License

MIT

