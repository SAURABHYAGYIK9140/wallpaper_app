import '../../domain/entities/wallpaper_entity.dart';

class WallpaperModel extends WallpaperEntity {
  const WallpaperModel({
    required super.id,
    required super.width,
    required super.height,
    required super.url,
    required super.photographer,
    required super.photographerUrl,
    required super.photographerId,
    required super.avgColor,
    required super.liked,
    required super.alt,
    required super.src,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      id: json['id'],
      width: json['width'],
      height: json['height'],
      url: json['url'],
      photographer: json['photographer'],
      photographerUrl: json['photographer_url'],
      photographerId: json['photographer_id'],
      avgColor: json['avg_color'],
      liked: json['liked'] ?? false,
      alt: json['alt'] ?? '',
      src: Map<String, String>.from(json['src']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'width': width,
      'height': height,
      'url': url,
      'photographer': photographer,
      'photographer_url': photographerUrl,
      'photographer_id': photographerId,
      'avg_color': avgColor,
      'liked': liked,
      'alt': alt,
      'src': src,
    };
  }
}
