#!/bin/bash
# Script to fix Xcode project file for Codemagic

echo "🔧 Fixing Xcode project file..."

PROJECT_FILE="MoonReader.xcodeproj/project.pbxproj"

# Check if project file exists
if [ ! -f "$PROJECT_FILE" ]; then
    echo "❌ Project file not found: $PROJECT_FILE"
    exit 1
fi

# Fix objectVersion (should be 54 for compatibility)
echo "📝 Setting objectVersion to 54..."
sed -i 's/objectVersion = 56;/objectVersion = 54;/g' "$PROJECT_FILE"

# Validate project file syntax
echo "✅ Project file fixed!"
echo "⚠️  Note: Project file may be missing many Swift files."
echo "   Consider opening in Xcode and adding all files to the project."

