# ⚠️ Vấn đề: Swift Files chưa được thêm vào Project

## Tình trạng hiện tại

Project file chỉ có `MoonReaderApp.swift`, nhưng cần **64 Swift files** khác.

## Giải pháp nhanh nhất

**Cách tốt nhất là mở project trong Xcode và thêm files:**

1. Mở project:
```bash
cd /home/camph/Documents/MoonReader/NewApp
open MoonReader.xcodeproj
```

2. Trong Xcode:
   - Right-click vào folder `MoonReader` (màu xanh)
   - Chọn **"Add Files to MoonReader..."**
   - Chọn tất cả các file Swift trong:
     - `Models/`
     - `Core/` (và tất cả subfolders)
     - `Views/` (và tất cả subfolders)
     - `ViewModels/`
     - `Utilities/`
   - ✅ Check **"Create groups"**
   - ✅ Check **"Add to targets: MoonReader"**
   - Click **"Add"**

3. Build và test:
   - ⌘+B để build
   - Nếu thành công, commit:
   ```bash
   git add MoonReader.xcodeproj/project.pbxproj
   git commit -m "Fix: Add all Swift files to Xcode project"
   git push
   ```

## Files quan trọng cần có

- `Core/Database/BookDatabase.swift`
- `Views/Library/BookShelfView.swift`
- `Views/Reader/ReadingView.swift`
- `Views/Settings/SettingsView.swift`
- Và tất cả 60+ files khác

## Lưu ý

Script tự động có thể gây lỗi duplicate IDs. Cách an toàn nhất là dùng Xcode GUI.

