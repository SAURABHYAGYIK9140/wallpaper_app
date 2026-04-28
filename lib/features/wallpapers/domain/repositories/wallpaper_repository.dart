import '../entities/wallpaper_entity.dart';

abstract class WallpaperRepository {
  Future<List<WallpaperEntity>> getCuratedWallpapers(int page, {int perPage = 10});
  Future<List<WallpaperEntity>> searchWallpapers(String query, int page, {int perPage = 10});
  Future<void> addToCollection(WallpaperEntity wallpaper);
  Future<void> removeFromCollection(int id);
  Future<List<WallpaperEntity>> getCollection();
  Future<bool> isInCollection(int id);
}
