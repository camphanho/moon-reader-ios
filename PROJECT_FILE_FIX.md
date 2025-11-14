# 🔧 Sửa lỗi Xcode Project File

## Vấn đề

Khi build trên Codemagic, bạn gặp lỗi:
```
xcodebuild: error: Unable to read project 'MoonReader.xcodeproj'.
Reason: The project 'Moon Reader' is damaged and cannot be opened.
Exception: -[PBXResourcesBuildPhase group]: unrecognized selector sent to instance
```

## Nguyên nhân

1. **objectVersion = 56** quá mới, không tương thích với Xcode 16.4
2. **Project file thiếu file references**: Project file chỉ có references đến một vài file cơ bản, nhưng thực tế có hàng chục file Swift trong project

## Giải pháp

### Giải pháp 1: Sửa trong Xcode (Khuyến nghị)

1. Mở project trong Xcode:
```bash
open MoonReader.xcodeproj
```

2. Xcode sẽ tự động detect các file Swift chưa được thêm vào project

3. Thêm tất cả files vào project:
   - Right-click vào folder `MoonReader` trong Project Navigator
   - Chọn "Add Files to MoonReader..."
   - Chọn tất cả các file Swift
   - ✅ Check "Copy items if needed" (nếu cần)
   - ✅ Check "Create groups"
   - ✅ Check target "MoonReader"
   - Click "Add"

4. Verify:
   - Build project (⌘+B)
   - Nếu build thành công, commit changes:
   ```bash
   git add MoonReader.xcodeproj/project.pbxproj
   git commit -m "Fix: Add all Swift files to Xcode project"
   git push
   ```

### Giải pháp 2: Tự động thêm files (Script)

Tạo script để tự động thêm files vào project:

```bash
# Tạo script add_files.sh
cat > add_files_to_project.sh << 'EOF'
#!/bin/bash
# Script to add Swift files to Xcode project

PROJECT_DIR="MoonReader"
PROJECT_FILE="MoonReader.xcodeproj/project.pbxproj"

echo "📁 Finding Swift files..."
find "$PROJECT_DIR" -name "*.swift" -type f | while read file; do
    echo "  - $file"
done

echo ""
echo "⚠️  This script cannot automatically add files to Xcode project."
echo "   Please use Xcode to add files manually (see PROJECT_FILE_FIX.md)"
EOF

chmod +x add_files_to_project.sh
```

### Giải pháp 3: Tạo lại project (Nếu cần)

Nếu project file bị corrupt nghiêm trọng:

1. Backup code:
```bash
cp -r MoonReader MoonReader_backup
```

2. Tạo project mới trong Xcode:
   - File → New → Project
   - iOS → App
   - Product Name: MoonReader
   - Interface: SwiftUI
   - Language: Swift

3. Copy files vào project mới:
```bash
cp -r MoonReader_backup/* MoonReader/
```

4. Add files vào project trong Xcode

## Kiểm tra Project File

Sau khi sửa, kiểm tra:

```bash
# Validate project
xcodebuild -list -project MoonReader.xcodeproj

# Build test
xcodebuild -project MoonReader.xcodeproj \
  -scheme MoonReader \
  -sdk iphonesimulator \
  -configuration Debug \
  clean build
```

## Cấu trúc Project File đúng

Project file nên có:
- ✅ objectVersion = 54 (không phải 56)
- ✅ Tất cả Swift files được reference trong PBXBuildFile section
- ✅ Tất cả files được reference trong PBXFileReference section
- ✅ Tất cả files được thêm vào PBXGroup section
- ✅ Tất cả files được thêm vào PBXSourcesBuildPhase hoặc PBXResourcesBuildPhase

## Files cần được thêm vào project

Dựa vào cấu trúc thư mục, các files sau cần được thêm:

### Models/
- Book.swift
- Bookmark.swift
- Note.swift
- ReadingStatistics.swift

### Core/
- BookManager.swift
- BookContentManager.swift
- Database/BookDatabase.swift
- Parsers/*.swift (tất cả parsers)
- TextRenderer/*.swift
- Search/BookSearchEngine.swift
- Statistics/ReadingTracker.swift
- TTS/TTSService.swift
- AutoScroll/AutoScrollManager.swift
- CloudSync/iCloudSync.swift
- OPDS/OPDSClient.swift

### Views/
- Library/*.swift
- Reader/*.swift
- Settings/*.swift
- Statistics/*.swift
- Common/*.swift

### ViewModels/
- ReaderViewModel.swift

### Utilities/
- *.swift (tất cả utilities)

## Sau khi sửa

1. Commit changes:
```bash
git add MoonReader.xcodeproj/project.pbxproj
git commit -m "Fix: Add all Swift files to Xcode project"
git push
```

2. Chạy lại build trên Codemagic

3. Verify build thành công

## Troubleshooting

### Lỗi "No such module"
- Kiểm tra file đã được thêm vào target chưa
- Kiểm tra import statements

### Lỗi "Missing file"
- Kiểm tra file paths trong project file
- Đảm bảo files tồn tại trong filesystem

### Lỗi "Duplicate symbols"
- Kiểm tra file không được thêm 2 lần
- Xóa duplicate references

## Tài liệu tham khảo

- [Xcode Project File Format](https://pewpewthespells.com/blog/xcode_pbxproj_format.html)
- [Codemagic iOS Build Guide](https://docs.codemagic.io/yaml/building/ios/)

