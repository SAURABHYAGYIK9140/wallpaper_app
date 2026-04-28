import '../repositories/wallpaper_repository.dart';

class RemoveFromCollection {
  final WallpaperRepository repository;

  RemoveFromCollection(this.repository);

  Future<void> call(int id) async {
    return await repository.removeFromCollection(id);
  }
}
