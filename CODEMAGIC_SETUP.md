# 🚀 Codemagic CI/CD Setup Guide

## Giới thiệu

Codemagic là một CI/CD service cho mobile apps, giúp tự động build và deploy iOS/Android apps.

## Bước 1: Tạo tài khoản Codemagic

1. Truy cập [codemagic.io](https://codemagic.io)
2. Sign up với GitHub/GitLab/Bitbucket
3. Connect repository của bạn

## Bước 2: Cấu hình Code Signing

### 2.1. App Store Connect API Key

1. Vào [App Store Connect](https://appstoreconnect.apple.com)
2. Users and Access → Keys → App Store Connect API
3. Tạo API key mới
4. Download `.p8` key file
5. Lưu Key ID và Issuer ID

### 2.2. Thêm vào Codemagic

1. Vào Codemagic → Teams → Integrations
2. App Store Connect → Add
3. Upload `.p8` file
4. Nhập Key ID và Issuer ID
5. Save với tên: `app_store_connect_api_key_credentials`

### 2.3. Code Signing Certificates

**Option 1: Automatic (Recommended)**
- Codemagic sẽ tự động tạo certificates
- Chỉ cần enable "Automatic code signing"

**Option 2: Manual**
1. Export certificates từ Keychain Access
2. Vào Codemagic → Teams → Code signing identities
3. Upload certificates và provisioning profiles
4. Save với tên: `certificate_credentials` và `provisioning_profile_credentials`

## Bước 3: Cấu hình codemagic.yaml

### 3.1. Copy example file
```bash
cp .codemagic.yaml.example codemagic.yaml
```

### 3.2. Chỉnh sửa codemagic.yaml

1. **Update email:**
```yaml
email:
  recipients:
    - your-email@example.com  # Đổi thành email của bạn
```

2. **Update Bundle ID:**
```yaml
vars:
  BUNDLE_ID: "com.yourname.moonreader"  # Đổi thành Bundle ID của bạn
```

3. **Uncomment App Store Connect (nếu muốn publish):**
```yaml
app_store_connect:
  auth: integration
  submit_to_testflight: true
```

## Bước 4: Push lên Repository

```bash
git add codemagic.yaml export_options.plist
git commit -m "Add Codemagic CI/CD configuration"
git push
```

## Bước 5: Chạy Build đầu tiên

1. Vào Codemagic dashboard
2. Chọn repository
3. Click "Start new build"
4. Chọn workflow: `ios-workflow`
5. Click "Start new build"

## Workflows có sẵn

### 1. ios-workflow
- Build IPA cho distribution
- Export với App Store method
- Publish lên TestFlight (nếu enabled)
- Gửi email notification

### 2. ios-simulator-workflow
- Build cho Simulator
- Chạy tests (nếu có)
- Nhanh hơn, dùng để test

## Cấu hình nâng cao

### Thêm Tests

Uncomment trong `ios-simulator-workflow`:
```yaml
- name: Run tests
  script: |
    xcodebuild \
      -project "$XCODE_WORKSPACE" \
      -scheme "$XCODE_SCHEME" \
      -sdk iphonesimulator \
      -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
      test | xcpretty
```

### Thêm CocoaPods

Nếu project dùng CocoaPods:
```yaml
scripts:
  - name: Install CocoaPods
    script: |
      pod install
```

### Thêm Environment Variables

Trong Codemagic dashboard:
1. Teams → Environment variables
2. Add variables
3. Reference trong yaml: `$ENV_VAR_NAME`

## Troubleshooting

### Build fails với "Code signing error"

**Giải pháp:**
1. Kiểm tra certificates đã upload chưa
2. Kiểm tra Bundle ID match với certificates
3. Enable "Automatic code signing" trong Codemagic

### Build fails với "No such module"

**Giải pháp:**
1. Thêm dependency installation script
2. Kiểm tra CocoaPods/Swift Package Manager setup

### TestFlight upload fails

**Giải pháp:**
1. Kiểm tra App Store Connect API key
2. Kiểm tra app đã tạo trong App Store Connect chưa
3. Kiểm tra Bundle ID match

### Build timeout

**Giải pháp:**
1. Tăng `max_build_duration` trong yaml
2. Optimize build scripts
3. Sử dụng build cache

## Best Practices

1. **Use build cache:**
```yaml
cache:
  cache_paths:
    - ~/.cocoapods
    - ~/Library/Developer/Xcode/DerivedData
```

2. **Separate workflows:**
- Development builds
- Release builds
- Test builds

3. **Conditional builds:**
```yaml
triggering:
  events:
    - push
      branches:
        - main
        - develop
```

4. **Notifications:**
- Email cho success/failure
- Slack/Discord integration
- GitHub status checks

## Pricing

- **Free tier:** 500 build minutes/month
- **Starter:** $75/month - 2,000 minutes
- **Professional:** $165/month - 5,000 minutes

## Resources

- [Codemagic Documentation](https://docs.codemagic.io/)
- [iOS Code Signing Guide](https://docs.codemagic.io/code-signing/ios-code-signing/)
- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)

## Next Steps

1. Setup Codemagic account
2. Configure code signing
3. Update codemagic.yaml với thông tin của bạn
4. Push và trigger build đầu tiên
5. Monitor builds và fix issues

Chúc bạn setup thành công! 🎉

