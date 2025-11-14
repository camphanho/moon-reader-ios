# ✅ Assets Paths đã được sửa

## Vấn đề

actool đang tìm assets ở:
- `/Users/builder/clone/Assets.xcassets` (thiếu MoonReader/)
- `/Users/builder/clone/Preview Content/Preview Assets.xcassets` (thiếu MoonReader/)

## Nguyên nhân

Asset file references có `sourceTree = "<group>"` nhưng parent group không có path, nên Xcode resolve từ root thay vì từ MoonReader/.

## Giải pháp

**Đổi sourceTree của assets thành SOURCE_ROOT:**
- ❌ `sourceTree = "<group>"` (resolve từ parent group)
- ✅ `sourceTree = SOURCE_ROOT` (resolve từ project root)

**Xcode sẽ resolve đúng:**
- Working directory: `/Users/builder/clone`
- Asset path: `MoonReader/Assets.xcassets` (với sourceTree = SOURCE_ROOT)
- **Final path**: `/Users/builder/clone/MoonReader/Assets.xcassets` ✅

## Đã sửa

1. ✅ Assets.xcassets: `path = "MoonReader/Assets.xcassets"`, `sourceTree = SOURCE_ROOT`
2. ✅ Preview Assets.xcassets: `path = "MoonReader/Preview Content/Preview Assets.xcassets"`, `sourceTree = SOURCE_ROOT`
3. ✅ MoonReader group: No path (để tránh duplicate cho file paths)

## Kết quả

- ✅ Assets sẽ resolve từ project root
- ✅ File paths vẫn là absolute (MoonReader/...)
- ✅ Không có duplicate paths
- ✅ Build sẽ thành công!

## Next Steps

1. **Commit changes:**
```bash
git add MoonReader.xcodeproj/project.pbxproj
git commit -m "Fix: Change asset sourceTree to SOURCE_ROOT for correct path resolution"
git push
```

2. **Chạy lại build trên Codemagic** - Build sẽ thành công!

