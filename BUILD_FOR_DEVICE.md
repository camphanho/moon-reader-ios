# 📱 Hướng dẫn Build và Cài App lên iPhone

## Yêu cầu

1. **Mac** với Xcode đã cài đặt
2. **iPhone/iPad** (iOS 15.0+)
3. **Apple ID** (có thể dùng Personal Team - miễn phí)
4. **USB Cable** để kết nối iPhone với Mac

## Bước 1: Chuẩn bị iPhone

### 1.1. Unlock iPhone
- Mở khóa iPhone
- Đảm bảo iPhone không ở chế độ Locked

### 1.2. Trust Computer (nếu lần đầu)
- Khi kết nối iPhone với Mac, iPhone sẽ hỏi "Trust This Computer?"
- Tap **Trust** và nhập passcode

### 1.3. Enable Developer Mode (iOS 16+)
1. Settings → Privacy & Security
2. Scroll xuống tìm **Developer Mode**
3. Bật **Developer Mode**
4. Restart iPhone nếu được yêu cầu

## Bước 2: Mở Project trong Xcode

```bash
cd /home/camph/Documents/MoonReader/NewApp
open MoonReader.xcodeproj
```

## Bước 3: Cấu hình Signing & Capabilities

### 3.1. Chọn Target
1. Trong Xcode, click vào project **MoonReader** ở sidebar bên trái
2. Chọn target **MoonReader** (không phải project)
3. Click tab **Signing & Capabilities**

### 3.2. Cấu hình Signing
1. **Automatically manage signing**: ✅ Bật (checked)
2. **Team**: Chọn Apple ID của bạn
   - Nếu chưa có, click **Add Account...**
   - Đăng nhập với Apple ID
   - Chọn team (sẽ hiện "Personal Team" nếu dùng Apple ID cá nhân)

### 3.3. Bundle Identifier
- Xcode sẽ tự động tạo Bundle ID (ví dụ: `com.yourname.MoonReader`)
- Nếu bị conflict, đổi thành unique ID (ví dụ: `com.yourname.moonreader.ios`)

### 3.4. Kiểm tra
- ✅ **Signing Certificate**: "Apple Development"
- ✅ **Provisioning Profile**: "Xcode Managed Profile"
- ✅ Không có lỗi màu đỏ

## Bước 4: Kết nối iPhone với Mac

### 4.1. Kết nối USB
1. Cắm USB cable vào iPhone và Mac
2. Unlock iPhone
3. Trust computer nếu được hỏi

### 4.2. Kiểm tra trong Xcode
1. Ở thanh toolbar, click vào device selector (bên cạnh nút Play)
2. iPhone của bạn sẽ xuất hiện trong danh sách
3. Chọn iPhone của bạn

## Bước 5: Build và Install

### 5.1. Build cho Device
1. **Chọn iPhone** ở device selector
2. Press `Command + B` để build
   - Hoặc: Product → Build
3. Chờ build hoàn tất (không có lỗi)

### 5.2. Run trên Device
1. Press `Command + R` để run
   - Hoặc: Product → Run
   - Hoặc: Click nút Play ▶️
2. Xcode sẽ:
   - Build app
   - Install lên iPhone
   - Launch app

### 5.3. Trust Developer trên iPhone (Lần đầu)
1. Khi app được install lần đầu, iPhone sẽ hiện:
   - "Untrusted Developer"
   - Settings → General → VPN & Device Management
2. Tap vào developer certificate
3. Tap **Trust "Your Name"**
4. Tap **Trust** để xác nhận
5. Quay lại app và mở lại

## Bước 6: Test trên iPhone

### 6.1. Import Sách từ Files App

1. **Chuẩn bị file sách:**
   - Copy file `.txt`, `.pdf`, `.rtf`, hoặc `.md` vào iPhone
   - Có thể dùng:
     - AirDrop từ Mac
     - Email file cho chính mình
     - iCloud Drive
     - Files app

2. **Import trong app:**
   - Mở Moon Reader app
   - Tap nút **+** (Import)
   - Chọn **Files**
   - Navigate đến file sách
   - Chọn file → Import

### 6.2. Test Các Tính Năng

- ✅ Đọc sách với swipe gestures
- ✅ Highlight text (long press)
- ✅ Search trong sách
- ✅ Settings (font, theme)
- ✅ Bookmarks
- ✅ TTS
- ✅ Statistics

## Troubleshooting

### Lỗi: "No signing certificate found"

**Giải pháp:**
1. Vào Signing & Capabilities
2. Click **Add Account...**
3. Đăng nhập với Apple ID
4. Chọn team

### Lỗi: "Provisioning profile doesn't match"

**Giải pháp:**
1. Xóa provisioning profile cũ:
   - Xcode → Preferences → Accounts
   - Chọn Apple ID → Download Manual Profiles
2. Clean build:
   - Product → Clean Build Folder (`Shift + Command + K`)
3. Build lại

### Lỗi: "Device not found"

**Giải pháp:**
1. Kiểm tra USB cable
2. Unlock iPhone
3. Trust computer trên iPhone
4. Restart Xcode
5. Disconnect và reconnect iPhone

### Lỗi: "Untrusted Developer"

**Giải pháp:**
1. Settings → General → VPN & Device Management
2. Tap vào developer certificate
3. Tap **Trust**
4. Mở lại app

### Lỗi: "App installation failed"

**Giải pháp:**
1. Kiểm tra iPhone có đủ storage không
2. Kiểm tra iOS version (cần iOS 15.0+)
3. Clean build và install lại

### Lỗi Build: "Code signing error"

**Giải pháp:**
1. Vào Signing & Capabilities
2. Uncheck "Automatically manage signing"
3. Check lại "Automatically manage signing"
4. Chọn team lại
5. Build lại

## Cách 2: Build Archive và Export (Cho TestFlight/App Store)

### 1. Archive
1. Chọn **Any iOS Device** ở device selector
2. Product → Archive
3. Chờ archive hoàn tất
4. Organizer sẽ mở

### 2. Export
1. Trong Organizer, chọn archive vừa tạo
2. Click **Distribute App**
3. Chọn **Development** (để test) hoặc **App Store Connect** (để publish)
4. Follow wizard để export

### 3. Install qua Xcode
1. Trong Organizer, click **Export**
2. Chọn location để save `.ipa` file
3. Có thể install `.ipa` qua:
   - Xcode → Window → Devices and Simulators
   - Hoặc dùng tools như 3uTools, iMazing

## Cách 3: TestFlight (Cho Beta Testing)

### 1. Upload lên App Store Connect
1. Archive app (như trên)
2. Distribute → App Store Connect
3. Upload lên App Store Connect

### 2. Setup TestFlight
1. Vào [App Store Connect](https://appstoreconnect.apple.com)
2. Chọn app
3. TestFlight → Internal Testing hoặc External Testing
4. Add testers
5. Testers sẽ nhận email invitation

## Lưu ý

### Personal Team Limitations
- App chỉ valid trong **7 ngày**
- Sau 7 ngày cần reinstall
- Tối đa **3 apps** cùng lúc
- Cần internet để verify mỗi lần mở app

### Paid Developer Account
- App valid **1 năm**
- Không giới hạn số apps
- Có thể publish lên App Store
- Có TestFlight

## Tips

1. **Enable Developer Mode** trên iPhone (iOS 16+)
2. **Keep iPhone unlocked** khi build/install
3. **Trust computer** trên iPhone
4. **Clean build** nếu gặp lỗi
5. **Check iOS version** (cần iOS 15.0+)

## Checklist

- [ ] iPhone đã unlock
- [ ] iPhone đã trust computer
- [ ] Developer Mode enabled (iOS 16+)
- [ ] Xcode đã detect iPhone
- [ ] Signing configured với team
- [ ] Build thành công
- [ ] App installed trên iPhone
- [ ] Trust developer certificate trên iPhone
- [ ] App chạy được
- [ ] Test import sách
- [ ] Test các tính năng

## Next Steps

Sau khi test thành công:
1. Fix bugs nếu có
2. Optimize performance
3. Prepare cho App Store (nếu muốn publish)
4. Setup TestFlight cho beta testing

Chúc bạn build và test thành công! 🎉

