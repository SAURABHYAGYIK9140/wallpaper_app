import 'package:flutter/material.dart';
import '../../domain/entities/wallpaper_entity.dart';

class WallpaperItem extends StatelessWidget {
  final WallpaperEntity wallpaper;
  final int index;

  const WallpaperItem({
    required this.wallpaper,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Accessing src map from entity
    String? portraitUrl = wallpaper.src['portrait'];
    String? mediumUrl = wallpaper.src['medium'];
    String? smallUrl = wallpaper.src['small'];

    String url = portraitUrl ?? '';
    if (index % 2 == 0) {
      url = mediumUrl ?? url;
    } else if (index % 3 == 0) {
      url = smallUrl ?? url;
    }

    return Container(
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 2.0)],
      ),
      child: Hero(
        tag: 'wallpaper_${wallpaper.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 200,
                color: Colors.grey[900],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.downloading, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
