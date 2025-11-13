# 📱 Hướng dẫn Test Moon Reader iOS

## Bước 1: Mở Project trong Xcode

### Cách 1: Từ Terminal
```bash
cd /home/camph/Documents/MoonReader/NewApp
open MoonReader.xcodeproj
```

### Cách 2: Từ Finder
1. Mở Finder
2. Điều hướng đến: `/home/camph/Documents/MoonReader/NewApp`
3. Double-click vào file `MoonReader.xcodeproj`

### Cách 3: Từ Xcode
1. Mở Xcode
2. File → Open
3. Chọn folder `NewApp`
4. Chọn file `MoonReader.xcodeproj`

## Bước 2: Kiểm tra Project Setup

### 2.1. Kiểm tra Target
1. Trong Xcode, chọn target **MoonReader** ở thanh toolbar
2. Đảm bảo:
   - **iOS Deployment Target**: iOS 15.0 hoặc cao hơn
   - **Device**: Chọn Simulator hoặc thiết bị thật

### 2.2. Kiểm tra Dependencies
Project hiện tại không cần external dependencies, nhưng nếu muốn parse EPUB thực sự:
- Có thể thêm ZIPFoundation qua Swift Package Manager (optional)

### 2.3. Kiểm tra Signing
1. Chọn target **MoonReader**
2. Vào tab **Signing & Capabilities**
3. Chọn **Team** của bạn (hoặc "Personal Team" cho development)
4. Xcode sẽ tự động tạo provisioning profile

## Bước 3: Build Project

### 3.1. Clean Build (nếu cần)
```
Product → Clean Build Folder (Shift + Command + K)
```

### 3.2. Build
```
Product → Build (Command + B)
```

Kiểm tra xem có lỗi nào không. Nếu có lỗi, xem phần Troubleshooting bên dưới.

## Bước 4: Chạy trên Simulator

### 4.1. Chọn Simulator
1. Ở thanh toolbar, click vào device selector
2. Chọn một iOS Simulator (ví dụ: iPhone 15 Pro, iOS 17.0)

### 4.2. Run App
```
Product → Run (Command + R)
```

Hoặc click nút **Play** ở thanh toolbar.

### 4.3. Chờ Simulator khởi động
- Simulator sẽ tự động mở
- App sẽ được cài đặt và chạy

## Bước 5: Test Các Tính Năng

### 5.1. Test Import Sách

1. **Chuẩn bị file sách test:**
   - Tạo file `.txt` với nội dung bất kỳ
   - Hoặc sử dụng file PDF, RTF, MD có sẵn

2. **Import sách:**
   - Trong app, tap nút **+** ở góc trên bên phải
   - Chọn **Import Book**
   - Trong Simulator, chọn **Files** app
   - Navigate đến file sách và chọn
   - App sẽ tự động parse và thêm vào thư viện

### 5.2. Test Đọc Sách

1. **Mở sách:**
   - Tap vào một cuốn sách trong thư viện
   - App sẽ load và hiển thị nội dung

2. **Test Navigation:**
   - Swipe trái/phải để chuyển trang
   - Tap vào màn hình để hiện/ẩn menu
   - Tap nút **<** hoặc **>** để chuyển trang

3. **Test Chapter Navigation:**
   - Tap icon **Mục lục** (list icon)
   - Chọn một chapter
   - App sẽ jump đến chapter đó

### 5.3. Test Text Selection & Highlight

1. **Chọn text:**
   - Long press vào một đoạn text
   - Text sẽ được highlight
   - Menu sẽ xuất hiện

2. **Tạo highlight:**
   - Tap **Highlight**
   - Chọn màu highlight
   - Highlight sẽ được lưu

3. **Xem bookmarks:**
   - Tap icon **Bookmark** (bookmark icon)
   - Xem danh sách bookmarks
   - Tap vào bookmark để jump đến vị trí

### 5.4. Test Search

1. **Search trong sách:**
   - Tap icon **Search** (magnifying glass)
   - Nhập từ khóa
   - Xem kết quả
   - Tap vào kết quả để jump đến vị trí

### 5.5. Test Settings

1. **Mở Settings:**
   - Tap icon **Settings** (gear icon)
   - Hoặc từ menu đọc sách

2. **Test các settings:**
   - Thay đổi font size
   - Thay đổi theme (Day/Night/AMOLED/Sepia)
   - Thay đổi margins
   - Thay đổi line spacing
   - Thay đổi text alignment

3. **Kiểm tra:**
   - Settings có apply ngay lập tức không
   - Text có render lại với settings mới không

### 5.6. Test TTS

1. **Mở TTS:**
   - Tap icon **Speaker** (speaker icon)
   - Hoặc từ menu đọc sách

2. **Test TTS:**
   - Tap **Play** để bắt đầu đọc
   - Điều chỉnh tốc độ
   - Test Play/Pause/Stop

### 5.7. Test Statistics

1. **Xem Statistics:**
   - Từ Settings → **Thống kê**
   - Xem reading time, words read
   - Xem calendar

2. **Kiểm tra:**
   - Statistics có update sau khi đọc không
   - Calendar có hiển thị đúng không

### 5.8. Test PDF Reading

1. **Import PDF:**
   - Import một file PDF
   - Mở PDF trong app

2. **Test PDF:**
   - Swipe để chuyển trang
   - Tap để hiện/ẩn menu
   - Test navigation

## Bước 6: Test trên Thiết Bị Thật (Optional)

### 6.1. Kết nối iPhone/iPad

1. Kết nối thiết bị qua USB
2. Unlock thiết bị
3. Trust computer nếu được hỏi

### 6.2. Chọn Device

1. Ở thanh toolbar, chọn thiết bị của bạn
2. Xcode sẽ tự động detect

### 6.3. Run

1. Click **Run** (Command + R)
2. Xcode sẽ build và install app lên thiết bị
3. App sẽ tự động chạy

### 6.4. Test với File Thật

1. **Import sách từ Files app:**
   - Mở Files app trên iPhone
   - Copy file sách vào Files
   - Mở Moon Reader app
   - Import từ Files app

2. **Test với iCloud:**
   - Nếu có iCloud, test sync feature
   - Upload sách lên iCloud
   - Download từ iCloud

## Troubleshooting

### Lỗi Build

**Lỗi: "No such module 'SwiftUI'"**
- Đảm bảo iOS Deployment Target >= iOS 15.0
- Clean build folder và build lại

**Lỗi: "Signing for MoonReader requires a development team"**
- Vào Signing & Capabilities
- Chọn Team của bạn
- Hoặc chọn "Personal Team"

**Lỗi: "Command PhaseScriptExecution failed"**
- Clean build folder
- Delete Derived Data
- Build lại

### Lỗi Runtime

**App crash khi import sách:**
- Kiểm tra file có đúng format không
- Kiểm tra console logs trong Xcode

**Text không hiển thị:**
- Kiểm tra file có encoding đúng không (UTF-8)
- Kiểm tra parser có hoạt động không

**PDF không load:**
- Kiểm tra file PDF có hợp lệ không
- Kiểm tra PDFKit có available không

### Debug Tips

1. **Xem Console Logs:**
   - Mở Debug Area (View → Debug Area → Show Debug Area)
   - Xem logs khi app chạy

2. **Breakpoints:**
   - Set breakpoints để debug
   - Step through code

3. **Inspect Variables:**
   - Hover over variables để xem giá trị
   - Sử dụng LLDB debugger

## Checklist Test

- [ ] Import sách (TXT, PDF, RTF, MD)
- [ ] Đọc sách với page navigation
- [ ] Chapter navigation
- [ ] Text selection và highlight
- [ ] Create/Edit/Delete bookmarks
- [ ] Search trong sách
- [ ] Settings (font, theme, margins)
- [ ] TTS
- [ ] Statistics
- [ ] PDF reading
- [ ] iCloud sync (nếu có)
- [ ] OPDS catalog (nếu có)

## Next Steps

Sau khi test xong:

1. **Fix bugs** nếu có
2. **Optimize performance** nếu cần
3. **Add unit tests** (optional)
4. **Prepare for App Store** nếu muốn publish

## Lưu ý

- EPUB parser hiện tại chỉ có structure, cần ZIPFoundation để parse EPUB thực sự
- Một số tính năng advanced (Cloud Sync, OPDS) cần test với network connection
- Test trên nhiều devices và iOS versions khác nhau

## Support

Nếu gặp vấn đề:
1. Kiểm tra console logs
2. Xem error messages
3. Kiểm tra code trong các files tương ứng
4. Tham khảo Apple documentation

Chúc bạn test thành công! 🎉

