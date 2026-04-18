class WallpaperEntity {
  final int id;
  final int width;
  final int height;
  final String url;
  final String photographer;
  final String photographerUrl;
  final int photographerId;
  final String avgColor;
  final bool liked;
  final String alt;
  final Map<String, String> src;

  const WallpaperEntity({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.photographerId,
    required this.avgColor,
    required this.liked,
    required this.alt,
    required this.src,
  });
}
