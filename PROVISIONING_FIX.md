# 🔐 Fix Lỗi Provisioning Profile

## ❌ Lỗi Gặp Phải

```
error: No profiles for 'com.moonreader.ios' were found: 
Xcode couldn't find any iOS App Development provisioning profiles 
matching 'com.moonreader.ios'. Automatic signing is disabled and 
unable to generate a profile. To enable automatic signing, pass 
-allowProvisioningUpdates to xcodebuild.
```

## ✅ ĐÃ FIX!

Đã thêm flag `-allowProvisioningUpdates` vào:
- ✅ Archive command
- ✅ Export command

---

## 🚀 Build Lại Ngay

### **Cách 1: Build trên Codemagic (Recommended)**

```bash
# Push code đã update
git add codemagic.yaml
git commit -m "Add -allowProvisioningUpdates flag"
git push

# Trigger build trên Codemagic
# → Xcode sẽ tự động tạo provisioning profile
```

### **Cách 2: Build Local**

```bash
cd /home/camph/Documents/MoonReader/NewApp

# Build với automatic provisioning
xcodebuild \
  -project MoonReader.xcodeproj \
  -scheme MoonReader \
  -sdk iphoneos \
  -configuration Release \
  -archivePath build/MoonReader.xcarchive \
  -allowProvisioningUpdates \
  DEVELOPMENT_TEAM="43AQ936H96" \
  archive
```

**Note:** Lần đầu build có thể yêu cầu bạn:
1. Đăng nhập Apple ID trong Xcode
2. Cho phép Xcode access keychain
3. Xác nhận tạo provisioning profile

---

## 🔍 Giải Thích

### Tại sao cần `-allowProvisioningUpdates`?

```
Khi dùng Automatic Signing:
├── Xcode cần tạo provisioning profile tự động
├── Nhưng xcodebuild CLI mặc định KHÔNG có quyền này
└── Flag -allowProvisioningUpdates cho phép Xcode:
    ├── Tạo App ID (nếu chưa có)
    ├── Tạo Provisioning Profile
    └── Đăng ký với Apple Developer Portal
```

### Alternative: Manual Signing

Nếu không muốn dùng automatic signing, có thể:

**1. Tạo Provisioning Profile thủ công:**
```
Apple Developer Portal:
1. Certificates, Identifiers & Profiles
2. Profiles → ➕ Create Profile
3. Select: "iOS App Development" hoặc "Ad Hoc"
4. Select App ID: com.moonreader.ios
5. Select Certificate
6. Select Devices (cho Ad Hoc)
7. Download .mobileprovision file
```

**2. Update project.pbxproj:**
```
CODE_SIGN_STYLE = Manual;
PROVISIONING_PROFILE_SPECIFIER = "MoonReader AdHoc";
```

**3. Update export_options.plist:**
```xml
<key>signingStyle</key>
<string>manual</string>
<key>provisioningProfiles</key>
<dict>
  <key>com.moonreader.ios</key>
  <string>MoonReader AdHoc</string>
</dict>
```

---

## 📋 Checklist

### Trước khi build:
- [x] ✅ Team ID đã set: `43AQ936H96`
- [x] ✅ Flag `-allowProvisioningUpdates` đã thêm
- [ ] ⏳ Apple ID đã đăng nhập trong Xcode (cho local build)
- [ ] ⏳ Bundle ID match: `com.moonreader.ios`

### Nếu build trên Codemagic:
- [x] ✅ `APPLE_TEAM_ID` đã set trong environment variables
- [ ] ⏳ (Optional) Apple ID credentials cho automatic signing
- [ ] ⏳ (Optional) Upload provisioning profile cho manual signing

---

## 🎯 Build Commands Updated

### Archive Command (OLD ❌)
```bash
xcodebuild \
  -project MoonReader.xcodeproj \
  -scheme MoonReader \
  -sdk iphoneos \
  -configuration Release \
  -archivePath build/MoonReader.xcarchive \
  DEVELOPMENT_TEAM="43AQ936H96" \
  archive
```

### Archive Command (NEW ✅)
```bash
xcodebuild \
  -project MoonReader.xcodeproj \
  -scheme MoonReader \
  -sdk iphoneos \
  -configuration Release \
  -archivePath build/MoonReader.xcarchive \
  -allowProvisioningUpdates \
  DEVELOPMENT_TEAM="43AQ936H96" \
  archive
```

**Khác biệt:** Thêm dòng `-allowProvisioningUpdates \`

---

## 🔐 About Provisioning Profiles

### Provisioning Profile là gì?
```
Provisioning Profile = Certificate + App ID + Devices + Entitlements

Nó xác định:
✅ App có thể chạy trên device nào
✅ Ai đã sign app (certificate)
✅ App có Bundle ID gì
✅ App có quyền gì (push, iCloud, etc.)
```

### Types of Provisioning Profiles:

| Type | Use Case | Expiry | Devices |
|------|----------|--------|---------|
| **Development** | Testing trên device của dev | 1 year | 100 devices |
| **Ad Hoc** | Beta testing | 1 year | 100 devices |
| **App Store** | Submit lên App Store | 1 year | Unlimited |
| **Enterprise** | Internal distribution | 1 year | Unlimited |

**Current config:** Ad Hoc (release-testing)

---

## 🆘 Troubleshooting

### Lỗi: "Apple ID credentials not found"
```bash
→ Giải pháp:
1. Xcode → Preferences → Accounts
2. Add Apple ID
3. Download manual provisioning profiles
4. Hoặc upload vào Codemagic
```

### Lỗi: "App ID not found"
```bash
→ Tạo App ID:
1. https://developer.apple.com/account
2. Identifiers → ➕
3. App IDs → Continue
4. Bundle ID: com.moonreader.ios
5. Register
```

### Lỗi: "Certificate not found"
```bash
→ Tạo Certificate:
1. https://developer.apple.com/account
2. Certificates → ➕
3. iOS App Development hoặc Distribution
4. Follow wizard
5. Download .cer file
6. Double click để install vào Keychain
```

### Build thành công nhưng không thể install?
```bash
→ Check:
1. Device UDID đã register?
2. Provisioning profile có chứa device này?
3. Certificate còn hạn?
4. App đã được trust trên device?
   Settings → General → VPN & Device Management
```

---

## 📊 Build Flow với Automatic Provisioning

```
┌─────────────────────────────────────────┐
│ 1. xcodebuild -allowProvisioningUpdates │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│ 2. Xcode kiểm tra Provisioning Profile  │
│    ├─ Có sẵn? → Dùng luôn              │
│    └─ Chưa có? → Tạo mới               │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│ 3. Connect Apple Developer Portal       │
│    ├─ Check App ID exists               │
│    ├─ Get Certificate                   │
│    └─ Get Devices (for Ad Hoc)          │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│ 4. Tạo Provisioning Profile             │
│    ├─ Link Certificate + App ID         │
│    ├─ Add Devices (if needed)           │
│    └─ Download về local                 │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│ 5. Sign App với Profile vừa tạo         │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│ 6. ✅ Archive thành công!               │
└─────────────────────────────────────────┘
```

---

## 💡 Best Practices

### 1. Automatic vs Manual Signing

**Automatic (Recommended for CI/CD):**
✅ Đơn giản, tự động
✅ Xcode quản lý profiles
✅ Tự động renew khi hết hạn
❌ Cần Apple ID credentials

**Manual (Recommended for Enterprise):**
✅ Kiểm soát tốt hơn
✅ Không cần credentials trong CI
✅ Dùng được Enterprise profiles
❌ Phức tạp hơn
❌ Phải manage profiles thủ công

### 2. Security

```bash
# KHÔNG commit vào Git:
❌ .p12 files (certificates)
❌ .mobileprovision files
❌ Keychain passwords
❌ Apple ID passwords

# Upload vào Codemagic:
✅ Certificates (trong Code signing identities)
✅ Provisioning profiles (trong Code signing identities)
✅ Apple ID (trong App Store Connect)
```

### 3. Expiry Management

```bash
# Certificates hết hạn sau 1 năm
# Provisioning profiles hết hạn sau 1 năm

→ Set reminder:
• 1 tháng trước expiry: Prepare new ones
• 1 tuần trước: Test với new profiles
• Ngay trước expiry: Switch production
```

---

## ✅ Summary

### Đã Fix:
- [x] ✅ Thêm `-allowProvisioningUpdates` flag
- [x] ✅ Update codemagic.yaml
- [x] ✅ Team ID đã set: `43AQ936H96`

### Next Steps:
1. Push code với codemagic.yaml mới
2. Trigger build trên Codemagic
3. Xcode sẽ tự động tạo provisioning profile
4. Build thành công → Download IPA

---

**Status: ✅ READY TO BUILD!**

Just push and build! 🚀

