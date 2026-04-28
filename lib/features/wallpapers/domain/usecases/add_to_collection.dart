import '../entities/wallpaper_entity.dart';
import '../repositories/wallpaper_repository.dart';

class AddToCollection {
  final WallpaperRepository repository;

  AddToCollection(this.repository);

  Future<void> call(WallpaperEntity wallpaper) async {
    return await repository.addToCollection(wallpaper);
  }
}
