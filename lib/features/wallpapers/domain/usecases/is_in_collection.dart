import '../repositories/wallpaper_repository.dart';

class IsInCollection {
  final WallpaperRepository repository;

  IsInCollection(this.repository);

  Future<bool> call(int id) async {
    return await repository.isInCollection(id);
  }
}
