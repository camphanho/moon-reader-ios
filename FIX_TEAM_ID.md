# ✅ Đã Sửa Lỗi "No Team Found in Archive"

## 🔧 Các thay đổi đã thực hiện:

### 1. **project.pbxproj** ✅
- Thêm `DEVELOPMENT_TEAM = "";` vào cả Debug và Release configuration
- Sẵn sàng nhận Team ID từ Codemagic

### 2. **export_options.plist** ✅
- Đổi method từ `ad-hoc` → `release-testing` (theo khuyến nghị của Apple)
- Đổi signingStyle từ `manual` → `automatic`
- Xóa provisioningProfiles (không cần với automatic signing)

### 3. **codemagic.yaml** ✅
- Thêm biến `APPLE_TEAM_ID` trong environment
- Thêm script tự động set Team ID trước khi build
- Build script hỗ trợ cả có và không có signing
- Export script thông minh hơn với error handling

---

## 📋 Hướng Dẫn Thiết Lập

### **Cách 1: Build trên Codemagic (Khuyến nghị)**

#### Bước 1: Lấy Apple Team ID
1. Đăng nhập vào [Apple Developer](https://developer.apple.com/account)
2. Vào **Membership** trong menu bên trái
3. Copy **Team ID** (dạng: `ABC1234DEF`)

#### Bước 2: Thêm Team ID vào Codemagic
1. Mở project trên Codemagic
2. Vào **Environment variables**
3. Thêm biến:
   - Key: `APPLE_TEAM_ID`
   - Value: `ABC1234DEF` (Team ID của bạn)
   - ✅ Check **Secure** (recommended)

#### Bước 3: Chạy Build
```bash
# Codemagic sẽ tự động:
# 1. Set Team ID vào project
# 2. Build với signing
# 3. Export IPA
```

### **Cách 2: Build Local (Cho Development)**

#### Option A: Với Signing
```bash
cd /path/to/NewApp

# Set Team ID của bạn
export APPLE_TEAM_ID="ABC1234DEF"

# Update project
sed -i.bak "s/DEVELOPMENT_TEAM = \"\";/DEVELOPMENT_TEAM = \"$APPLE_TEAM_ID\";/g" \
  MoonReader.xcodeproj/project.pbxproj

# Build
xcodebuild \
  -project MoonReader.xcodeproj \
  -scheme MoonReader \
  -sdk iphoneos \
  -configuration Release \
  -archivePath build/MoonReader.xcarchive \
  DEVELOPMENT_TEAM="$APPLE_TEAM_ID" \
  archive

# Export IPA
xcodebuild \
  -exportArchive \
  -archivePath build/MoonReader.xcarchive \
  -exportOptionsPlist export_options.plist \
  -exportPath build/ios/ipa
```

#### Option B: Không Signing (Test Build)
```bash
cd /path/to/NewApp

# Build without signing
xcodebuild \
  -project MoonReader.xcodeproj \
  -scheme MoonReader \
  -sdk iphoneos \
  -configuration Release \
  -archivePath build/MoonReader.xcarchive \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  archive
```

### **Cách 3: Build trong Xcode**

1. Mở `MoonReader.xcodeproj` trong Xcode
2. Chọn project trong Navigator (file màu xanh ở trên cùng)
3. Chọn Target **MoonReader**
4. Vào tab **Signing & Capabilities**
5. Chọn Team từ dropdown
6. Xcode sẽ tự động setup signing
7. Product → Archive

---

## 🎯 Giải Thích Các Lỗi Đã Sửa

### ❌ Lỗi cũ:
```
error: exportArchive No Team Found in Archive
```

### ✅ Nguyên nhân:
1. Project không có `DEVELOPMENT_TEAM` trong build settings
2. `export_options.plist` dùng manual signing nhưng thiếu team info
3. Method `ad-hoc` đã deprecated

### ✅ Đã sửa:
1. ✅ Thêm `DEVELOPMENT_TEAM` field vào project
2. ✅ Đổi sang automatic signing
3. ✅ Dùng method mới `release-testing`
4. ✅ Codemagic tự động inject Team ID

---

## 🔍 Kiểm Tra Cấu Hình

### Kiểm tra Team ID đã được set:
```bash
grep -A 2 "DEVELOPMENT_TEAM" MoonReader.xcodeproj/project.pbxproj
```

**Kết quả mong đợi:**
```
DEVELOPMENT_TEAM = "";  # Hoặc Team ID nếu đã set
```

### Kiểm tra export_options.plist:
```bash
cat export_options.plist | grep -A 1 "method\|signingStyle"
```

**Kết quả mong đợi:**
```xml
<key>method</key>
<string>release-testing</string>
<key>signingStyle</key>
<string>automatic</string>
```

---

## 🚀 Build Flow Hoàn Chỉnh

```
┌─────────────────────────────────────┐
│   1. Set APPLE_TEAM_ID              │
│      (Codemagic Environment Var)    │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   2. Update project.pbxproj         │
│      DEVELOPMENT_TEAM = "ABC..."    │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   3. xcodebuild archive             │
│      (với Team ID)                  │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   4. xcodebuild -exportArchive      │
│      (automatic signing)            │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   5. ✅ MoonReader.ipa READY!       │
└─────────────────────────────────────┘
```

---

## ❓ FAQ

### Q: Tôi không có Apple Developer Account?
**A:** Bạn có thể:
- Build without signing (cho test)
- Hoặc dùng Free Provisioning Profile (giới hạn 7 ngày)
- Hoặc đăng ký Apple Developer Program ($99/năm)

### Q: Lỗi "No signing certificate found"?
**A:** 
1. Tạo certificate trong Apple Developer Portal
2. Upload lên Codemagic trong **Code signing identities**
3. Hoặc dùng automatic signing (Codemagic tự quản lý)

### Q: Build thành công nhưng không có IPA?
**A:** Check:
1. Archive có tồn tại: `ls -la build/MoonReader.xcarchive`
2. Team ID đã được set đúng
3. Signing certificates đã được cài đặt

### Q: Muốn build cho App Store?
**A:** Đổi method trong `export_options.plist`:
```xml
<key>method</key>
<string>app-store</string>
```

---

## 📝 Notes

- ⚠️ **DEVELOPMENT_TEAM = ""** nghĩa là chưa set Team ID
- 🔐 Team ID phải match với signing certificate
- 📱 `release-testing` = ad-hoc build (cài trên device đã đăng ký)
- 🏪 `app-store` = build để submit lên App Store
- 🧪 `development` = build cho development/testing

---

## ✅ Checklist Build Thành Công

- [ ] APPLE_TEAM_ID đã set trong Codemagic
- [ ] Signing certificate đã upload (nếu dùng manual signing)
- [ ] Bundle ID match với App ID trong Apple Developer
- [ ] Device UDID đã đăng ký (cho ad-hoc/development)
- [ ] Provisioning profile đúng type
- [ ] Project không có lỗi compilation

---

## 🆘 Liên Hệ

Nếu gặp vấn đề, check:
1. Build logs trong Codemagic
2. File `build.log` (nếu build local)
3. Xcode signing errors trong **Report Navigator**

**Email support:** camph.dev.96@gmail.com

