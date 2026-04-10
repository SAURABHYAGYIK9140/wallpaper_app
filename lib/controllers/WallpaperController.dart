import 'package:get/get.dart';
import 'package:wallpaper_app/models/WallpaperModel.dart';
import 'package:wallpaper_app/services/WallpaperRepository.dart';

class WallpaperController extends GetxController {
  final WallpaperRepository _repository = WallpaperRepository();

  // Observables
  final Rx<List<WallpaperModel>> wallpapers = Rx<List<WallpaperModel>>([]);
  final Rx<List<WallpaperModel>> trendingWallpapers = Rx<List<WallpaperModel>>([]);
  final Rx<List<WallpaperModel>> latestWallpapers = Rx<List<WallpaperModel>>([]);
  final Rx<List<String>> categories = Rx<List<String>>([]);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrendingWallpapers();
    fetchLatestWallpapers();
    fetchCategories();
  }

  // ============ FETCH OPERATIONS ============

  /// Fetch all wallpapers
  Future<void> fetchAllWallpapers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await _repository.getAllWallpapers();
      wallpapers.value = data;
    } catch (e) {
      errorMessage.value = 'Error fetching wallpapers: $e';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch trending wallpapers
  Future<void> fetchTrendingWallpapers() async {
    try {
      isLoading.value = true;
      final data = await _repository.getTrendingWallpapers(limit: 10);
      trendingWallpapers.value = data;
    } catch (e) {
      print('Error fetching trending wallpapers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch latest wallpapers
  Future<void> fetchLatestWallpapers() async {
    try {
      isLoading.value = true;
      final data = await _repository.getLatestWallpapers(limit: 10);
      latestWallpapers.value = data;
    } catch (e) {
      print('Error fetching latest wallpapers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch wallpapers by category
  Future<void> fetchWallpapersByCategory(String category) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await _repository.getWallpapersByCategory(category);
      wallpapers.value = data;
    } catch (e) {
      errorMessage.value = 'Error fetching category wallpapers: $e';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Search wallpapers
  Future<void> searchWallpapers(String query) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      if (query.isEmpty) {
        wallpapers.value = [];
        return;
      }
      final data = await _repository.searchWallpapers(query);
      wallpapers.value = data;
    } catch (e) {
      errorMessage.value = 'Error searching wallpapers: $e';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch categories
  Future<void> fetchCategories() async {
    try {
      final data = await _repository.getCategories();
      categories.value = data;
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  // ============ STREAM OPERATIONS ============

  /// Stream all wallpapers (real-time updates)
  Stream<List<WallpaperModel>> streamAllWallpapers() {
    return _repository.streamWallpapers();
  }

  /// Stream wallpapers by category
  Stream<List<WallpaperModel>> streamWallpapersByCategory(String category) {
    return _repository.streamWallpapersByCategory(category);
  }

  // ============ LIKE OPERATIONS ============

  /// Toggle like for a wallpaper
  Future<void> toggleLike(String id, bool currentlyLiked) async {
    try {
      if (currentlyLiked) {
        await _repository.decrementLikes(id);
      } else {
        await _repository.incrementLikes(id);
      }
    } catch (e) {
      errorMessage.value = 'Error toggling like: $e';
      print(errorMessage.value);
    }
  }

  /// Increment downloads
  Future<void> incrementDownloads(String id) async {
    try {
      await _repository.incrementDownloads(id);
    } catch (e) {
      errorMessage.value = 'Error incrementing downloads: $e';
      print(errorMessage.value);
    }
  }

  // ============ ADMIN OPERATIONS ============

  /// Add new wallpaper (admin function)
  Future<String?> addNewWallpaper(WallpaperModel wallpaper) async {
    try {
      isLoading.value = true;
      final id = await _repository.addWallpaper(wallpaper);
      return id;
    } catch (e) {
      errorMessage.value = 'Error adding wallpaper: $e';
      print(errorMessage.value);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update wallpaper (admin function)
  Future<void> updateWallpaper(String id, WallpaperModel wallpaper) async {
    try {
      isLoading.value = true;
      await _repository.updateWallpaper(id, wallpaper);
    } catch (e) {
      errorMessage.value = 'Error updating wallpaper: $e';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete wallpaper (admin function)
  Future<void> deleteWallpaper(String id) async {
    try {
      isLoading.value = true;
      await _repository.deleteWallpaper(id);
      await fetchAllWallpapers();
    } catch (e) {
      errorMessage.value = 'Error deleting wallpaper: $e';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}

