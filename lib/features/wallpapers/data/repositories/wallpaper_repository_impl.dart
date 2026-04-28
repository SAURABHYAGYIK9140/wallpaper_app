import '../../domain/entities/wallpaper_entity.dart';
import '../../domain/repositories/wallpaper_repository.dart';
import '../data_sources/wallpaper_local_data_source.dart';
import '../data_sources/wallpaper_remote_data_source.dart';
import '../models/wallpaper_model.dart';

class WallpaperRepositoryImpl implements WallpaperRepository {
  final WallpaperRemoteDataSource remoteDataSource;
  final WallpaperLocalDataSource localDataSource;

  WallpaperRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<WallpaperEntity>> getCuratedWallpapers(int page, {int perPage = 10}) async {
    try {
      final List<WallpaperEntity> wallpapers = await remoteDataSource.getCuratedWallpapers(page, perPage: perPage);
      return wallpapers;
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  @override
  Future<List<WallpaperEntity>> searchWallpapers(String query, int page, {int perPage = 10}) async {
    try {
      final List<WallpaperEntity> wallpapers = await remoteDataSource.searchWallpapers(query, page, perPage: perPage);
      return wallpapers;
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  @override
  Future<void> addToCollection(WallpaperEntity wallpaper) async {
    await localDataSource.addToCollection(
      WallpaperModel(
        id: wallpaper.id,
        width: wallpaper.width,
        height: wallpaper.height,
        url: wallpaper.url,
        photographer: wallpaper.photographer,
        photographerUrl: wallpaper.photographerUrl,
        photographerId: wallpaper.photographerId,
        avgColor: wallpaper.avgColor,
        liked: wallpaper.liked,
        alt: wallpaper.alt,
        src: wallpaper.src,
      ),
    );
  }

  @override
  Future<void> removeFromCollection(int id) async {
    await localDataSource.removeFromCollection(id);
  }

  @override
  Future<List<WallpaperEntity>> getCollection() async {
    return await localDataSource.getCollection();
  }

  @override
  Future<bool> isInCollection(int id) async {
    return await localDataSource.isInCollection(id);
  }
}
