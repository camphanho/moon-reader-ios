# 🚀 Codemagic Quick Setup Guide

## ⚡ Setup Nhanh trong 5 Phút

### 1️⃣ Lấy Apple Team ID (2 phút)

```bash
# Đăng nhập: https://developer.apple.com/account
# → Membership → Copy Team ID (VD: ABC1234DEF)
```

### 2️⃣ Thêm vào Codemagic (1 phút)

**Trong Codemagic Web UI:**

```
Settings → Environment variables → Add Variable
┌────────────────────────────────┐
│ Variable name: APPLE_TEAM_ID   │
│ Value: ABC1234DEF              │
│ ✅ Secure                      │
│ Group: (optional)              │
└────────────────────────────────┘
```

### 3️⃣ (Optional) Setup Code Signing

**Option A: Automatic Signing (Đơn giản)**
```
✅ Đã setup sẵn trong export_options.plist
✅ Codemagic tự động quản lý certificates
✅ Không cần làm gì thêm!
```

**Option B: Manual Signing (Nâng cao)**
```
Settings → Code signing identities
1. Upload .p12 certificate file
2. Enter certificate password
3. Upload provisioning profile (.mobileprovision)
```

### 4️⃣ Chạy Build (30 giây)

```
Start new build → Workflow: ios-local-build → Start build
```

### 5️⃣ Tải IPA

```
Build thành công → Artifacts → Download MoonReader.ipa
```

---

## 🔑 Environment Variables Cần Thiết

| Variable | Required | Example | Mô tả |
|----------|----------|---------|-------|
| `APPLE_TEAM_ID` | ✅ YES | `ABC1234DEF` | Apple Developer Team ID |
| `APP_STORE_CONNECT_KEY_ID` | ❌ Optional | `ABC123XYZ` | Cho auto publish |
| `APP_STORE_CONNECT_ISSUER_ID` | ❌ Optional | `xxx-xxx-xxx` | Cho auto publish |
| `CERTIFICATE_PRIVATE_KEY` | ❌ Optional | `-----BEGIN...` | Cho manual signing |

---

## 📱 Device Registration (Cho Ad-Hoc Build)

### Lấy Device UDID:

**Cách 1: Từ iPhone**
```
Settings → General → About → UDID (tap to copy)
```

**Cách 2: Từ Xcode**
```
Window → Devices and Simulators → Select device → Identifier
```

**Cách 3: Từ Finder (macOS Catalina+)**
```
Connect iPhone → Finder → Click phone → General info
```

### Đăng ký Device trên Apple Developer:

```
1. https://developer.apple.com/account/resources/devices
2. Click ➕ Register New Device
3. Nhập:
   - Device Name: "My iPhone 15"
   - UDID: xxxxxxxxxxxxxxxxxxxx
4. Save
```

---

## 🏗️ Build Configurations

### Development Build (Test trên device của bạn)
```yaml
# Trong export_options.plist
<key>method</key>
<string>development</string>
```

### Ad-Hoc Build (Test trên nhiều device đã đăng ký)
```yaml
# Trong export_options.plist  
<key>method</key>
<string>release-testing</string>  # ✅ Đã setup sẵn
```

### App Store Build (Submit lên App Store)
```yaml
# Trong export_options.plist
<key>method</key>
<string>app-store</string>
```

---

## 🐛 Troubleshooting

### ❌ "No Team Found in Archive"
```bash
✅ ĐÃ FIX! Check:
- APPLE_TEAM_ID đã set trong Codemagic? 
- Team ID đúng format (10 ký tự)?
```

### ❌ "No signing certificate found"
```bash
→ Cài certificates:
  Settings → Code signing identities → Upload .p12
→ Hoặc dùng automatic signing (đã setup sẵn)
```

### ❌ "No matching provisioning profile found"
```bash
→ Check Bundle ID match:
  Project: com.moonreader.ios
  Apple Developer: com.moonreader.ios (phải giống)
→ Upload provisioning profile vào Codemagic
```

### ❌ "Swift compilation errors"
```bash
✅ ĐÃ FIX tất cả Swift errors!
→ Nếu vẫn lỗi: check build log chi tiết
```

### ❌ Build timeout
```bash
→ Tăng max_build_duration trong codemagic.yaml:
  max_build_duration: 120  # 2 hours
```

---

## 📊 Build Status Flow

```
🔄 Queued
  ↓
🔨 Building
  ├── Fix project file       ✅
  ├── Install dependencies   ✅
  ├── Set Team ID            ✅
  ├── Archive project        ⏳ (10-15 min)
  └── Export IPA             ⏳ (2-3 min)
  ↓
✅ Success → Download IPA
❌ Failed → Check logs
```

---

## 🎯 Typical Build Times

| Step | Time | Can Optimize? |
|------|------|---------------|
| Setup | ~1 min | ❌ Fixed |
| Install Pods | ~2 min | ✅ Cache |
| Compile Swift | ~10 min | ✅ Incremental |
| Archive | ~2 min | ❌ Fixed |
| Export | ~1 min | ❌ Fixed |
| **TOTAL** | **~15-20 min** | |

### Optimization Tips:
```yaml
cache:
  cache_paths:
    - $HOME/Library/Caches/CocoaPods
    - Pods
```

---

## 🔐 Security Best Practices

1. ✅ **Secure variables**: Always check "Secure" cho:
   - APPLE_TEAM_ID
   - API keys
   - Certificates passwords

2. ✅ **Private repo**: Keep repo private nếu có sensitive data

3. ✅ **Rotate credentials**: Đổi certificates định kỳ

4. ✅ **Access control**: Giới hạn ai có quyền access Codemagic

---

## 📧 Email Notifications

Đã setup sẵn trong `codemagic.yaml`:

```yaml
publishing:
  email:
    recipients:
      - camph.dev.96@gmail.com
    notify:
      success: true  # ✅ Nhận email khi success
      failure: true  # ✅ Nhận email khi failed
```

**Email sẽ chứa:**
- Build status
- Build logs
- Download links cho artifacts
- Error messages (nếu failed)

---

## 🎨 Codemagic Badge

Thêm build status badge vào README.md:

```markdown
[![Codemagic build status](
  https://api.codemagic.io/apps/<app-id>/status_badge.svg
)](
  https://codemagic.io/apps/<app-id>/latest_build
)
```

---

## 📚 Resources

- [Codemagic Docs](https://docs.codemagic.io/)
- [iOS Code Signing Guide](https://docs.codemagic.io/code-signing-yaml/signing-ios/)
- [Apple Developer Portal](https://developer.apple.com/account)
- [App Store Connect](https://appstoreconnect.apple.com/)

---

## ✨ Next Steps

Sau khi build thành công:

1. 🧪 **Test IPA**: Install trên device
2. 🐛 **Fix bugs**: Nếu có issues
3. 📱 **TestFlight**: Upload cho beta testing
4. 🏪 **App Store**: Submit khi sẵn sàng
5. 🎉 **Launch**: Publish app!

---

**Happy Building! 🚀**

