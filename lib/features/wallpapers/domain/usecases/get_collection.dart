import '../entities/wallpaper_entity.dart';
import '../repositories/wallpaper_repository.dart';

class GetCollection {
  final WallpaperRepository repository;

  GetCollection(this.repository);

  Future<List<WallpaperEntity>> call() async {
    return await repository.getCollection();
  }
}
