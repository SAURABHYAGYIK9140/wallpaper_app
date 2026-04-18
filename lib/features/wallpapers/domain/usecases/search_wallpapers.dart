import '../entities/wallpaper_entity.dart';
import '../repositories/wallpaper_repository.dart';

class SearchWallpapers {
  final WallpaperRepository repository;

  SearchWallpapers(this.repository);

  Future<List<WallpaperEntity>> call(String query, int page, {int perPage = 10}) async {
    return await repository.searchWallpapers(query, page, perPage: perPage);
  }
}
