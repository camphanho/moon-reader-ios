#!/bin/bash

# Script để mở Moon Reader iOS project trong Xcode

PROJECT_PATH="/home/camph/Documents/MoonReader/NewApp"
PROJECT_FILE="MoonReader.xcodeproj"

cd "$PROJECT_PATH"

if [ -d "$PROJECT_FILE" ]; then
    echo "✅ Tìm thấy project file"
    echo "📱 Đang mở Xcode..."
    open "$PROJECT_FILE"
    echo "✨ Xcode đã mở project!"
    echo ""
    echo "📝 Tiếp theo:"
    echo "   1. Chọn Simulator (iPhone 15 Pro)"
    echo "   2. Press Command + R để run"
    echo "   3. Xem TESTING_GUIDE.md để test chi tiết"
else
    echo "❌ Không tìm thấy project file: $PROJECT_FILE"
    echo "📂 Đang ở thư mục: $(pwd)"
    echo "📋 Files trong thư mục:"
    ls -la
fi

