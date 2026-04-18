import '../entities/wallpaper_entity.dart';
import '../repositories/wallpaper_repository.dart';

class GetCuratedWallpapers {
  final WallpaperRepository repository;

  GetCuratedWallpapers(this.repository);

  Future<List<WallpaperEntity>> call(int page, {int perPage = 10}) async {
    return await repository.getCuratedWallpapers(page, perPage: perPage);
  }
}
