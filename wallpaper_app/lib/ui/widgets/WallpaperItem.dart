import 'package:flutter/material.dart';

import '../../models/Wallpaper.dart';
class WallpaperItem extends StatelessWidget {
  final Wallpaper wallpaper;

  const WallpaperItem({required this.wallpaper});

  @override
  Widget build(BuildContext context) {
    return Container(

      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          wallpaper.src.large2X,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(child: Text('Error loading image')),
        ),
      ),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color:Colors.black, blurRadius: 2.0)],
      ),
    );
  }
}