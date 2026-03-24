import 'package:flutter/material.dart';
import '../../models/Wallpaper.dart';

class WallpaperItem extends StatelessWidget {
  final Wallpaper wallpaper;
  final int index;

  const WallpaperItem({
    required this.wallpaper,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    String url = wallpaper.src.portrait;
    if (index % 2 == 0) {
      url = wallpaper.src.medium;
    } else if (index % 3 == 0) {
      url = wallpaper.src.small;
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 2.0)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Center(child: Icon(Icons.downloading)),
        ),
      ),
    );
  }
}
