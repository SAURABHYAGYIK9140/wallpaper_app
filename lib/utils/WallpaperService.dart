import 'package:flutter/services.dart';

class WallpaperService {
  static const platform = MethodChannel('com.example.wallpaper/setWallpaper');

  static Future<void> setWallpaperFromFile(String imagePath, int wallpaperLocation) async {
    try {
      final bool result = await platform.invokeMethod('setWallpaperFromFile', {
        "filePath": imagePath,
        "wallpaperLocation": wallpaperLocation,
      });
      if (result) {
        print('Wallpaper set successfully');
      } else {
        print('Failed to set wallpaper');
      }
    } on PlatformException catch (e) {
      print("Failed to set wallpaper: '${e.message}'.");
    }
  }
}
