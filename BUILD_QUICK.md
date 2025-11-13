# ⚡ Quick Build Guide - iPhone

## 5 Bước Nhanh

### 1. Kết nối iPhone
```
Cắm USB → Unlock iPhone → Trust Computer
```

### 2. Mở Xcode
```bash
cd /home/camph/Documents/MoonReader/NewApp
open MoonReader.xcodeproj
```

### 3. Cấu hình Signing
- Click project → Target **MoonReader**
- Tab **Signing & Capabilities**
- ✅ **Automatically manage signing**
- Chọn **Team** (Apple ID của bạn)

### 4. Chọn iPhone
- Device selector → Chọn iPhone của bạn

### 5. Build & Run
```
Command + R
```

## Lần đầu cần làm

### Trên iPhone:
1. Settings → General → VPN & Device Management
2. Tap developer certificate
3. Tap **Trust**

### Trên Mac:
- Enable Developer Mode (iOS 16+)
- Trust computer trên iPhone

## Troubleshooting

**"No signing certificate"**
→ Thêm Apple ID trong Signing & Capabilities

**"Device not found"**
→ Unlock iPhone, trust computer, reconnect

**"Untrusted Developer"**
→ Settings → General → VPN & Device Management → Trust

Xem `BUILD_FOR_DEVICE.md` để biết chi tiết!

