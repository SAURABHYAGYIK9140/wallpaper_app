import '../../domain/entities/wallpaper_entity.dart';
import '../../domain/repositories/wallpaper_repository.dart';
import '../data_sources/wallpaper_remote_data_source.dart';

class WallpaperRepositoryImpl implements WallpaperRepository {
  final WallpaperRemoteDataSource remoteDataSource;

  WallpaperRepositoryImpl({required this.remoteDataSource});

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
}
