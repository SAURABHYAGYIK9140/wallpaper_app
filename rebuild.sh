#!/bin/bash
set -e

cd /Users/Hasim/Downloads/wallpaper/wallpaper_app

echo "============================================"
echo "Step 1: Removing build artifacts"
echo "============================================"
rm -rf build/
rm -rf .dart_tool/
rm -rf android/.gradle/
rm -rf android/app/build/
rm -rf android/app/.gradle/

echo "============================================"
echo "Step 2: Getting fresh Flutter dependencies"
echo "============================================"
flutter pub get --no-example

echo "============================================"
echo "Step 3: Running Flutter clean"
echo "============================================"
flutter clean

echo "============================================"
echo "Step 4: Getting dependencies again post-clean"
echo "============================================"
flutter pub get

echo "============================================"
echo "Step 5: Building release APK"
echo "============================================"
flutter build apk --release

echo "============================================"
echo "✅ Build completed successfully!"
echo "============================================"

