import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallpaper_app/models/WallpaperModel.dart';
import 'package:wallpaper_app/services/FirebaseService.dart';

class WallpaperRepository {
  final FirebaseService _firebaseService = FirebaseService();

  static const String collectionName = 'wallpapers';

  // ============ READ OPERATIONS ============

  /// Get all wallpapers
  Future<List<WallpaperModel>> getAllWallpapers() async {
    try {
      final querySnapshot = await _firebaseService.getAllDocuments(collectionName);
      return querySnapshot.docs
          .map((doc) => WallpaperModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting all wallpapers: $e');
      rethrow;
    }
  }

  /// Get wallpaper by ID
  Future<WallpaperModel?> getWallpaperById(String id) async {
    try {
      final docSnapshot = await _firebaseService.getDocument(collectionName, id);
      if (docSnapshot.exists) {
        return WallpaperModel.fromFirestore(
            docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      }
      return null;
    } catch (e) {
      print('Error getting wallpaper by ID: $e');
      rethrow;
    }
  }

  /// Get wallpapers by category
  Future<List<WallpaperModel>> getWallpapersByCategory(String category) async {
    try {
      final querySnapshot = await _firebaseService.getDocumentsWhere(
        collectionName,
        'category',
        category,
      );
      return querySnapshot.docs
          .map((doc) => WallpaperModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting wallpapers by category: $e');
      rethrow;
    }
  }

  /// Get trending wallpapers (sorted by likes and downloads)
  Future<List<WallpaperModel>> getTrendingWallpapers({int limit = 10}) async {
    try {
      final querySnapshot = await _firebaseService.getDocumentsWithLimit(
        collectionName,
        limit: limit,
        orderBy: 'likes',
        descending: true,
      );
      return querySnapshot.docs
          .map((doc) => WallpaperModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting trending wallpapers: $e');
      rethrow;
    }
  }

  /// Get latest wallpapers
  Future<List<WallpaperModel>> getLatestWallpapers({int limit = 10}) async {
    try {
      final querySnapshot = await _firebaseService.getDocumentsWithLimit(
        collectionName,
        limit: limit,
        orderBy: 'createdAt',
        descending: true,
      );
      return querySnapshot.docs
          .map((doc) => WallpaperModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting latest wallpapers: $e');
      rethrow;
    }
  }

  /// Search wallpapers by title or tags
  Future<List<WallpaperModel>> searchWallpapers(String query) async {
    try {
      final querySnapshot =
          await _firebaseService.firestore.collection(collectionName).get();

      final results = querySnapshot.docs
          .where((doc) {
            final data = doc.data();
            final title = (data['title'] ?? '').toString().toLowerCase();
            final tags = (data['tags'] ?? '').toString().toLowerCase();
            final description =
                (data['description'] ?? '').toString().toLowerCase();
            final searchQuery = query.toLowerCase();

            return title.contains(searchQuery) ||
                tags.contains(searchQuery) ||
                description.contains(searchQuery);
          })
          .map((doc) => WallpaperModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      return results;
    } catch (e) {
      print('Error searching wallpapers: $e');
      rethrow;
    }
  }

  /// Stream wallpapers (real-time updates)
  Stream<List<WallpaperModel>> streamWallpapers() {
    try {
      return _firebaseService.streamCollection(collectionName).map((snapshot) =>
          snapshot.docs
              .map((doc) => WallpaperModel.fromFirestore(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList());
    } catch (e) {
      print('Error streaming wallpapers: $e');
      rethrow;
    }
  }

  /// Stream wallpapers by category (real-time updates)
  Stream<List<WallpaperModel>> streamWallpapersByCategory(String category) {
    try {
      return _firebaseService
          .streamCollectionWhere(collectionName, 'category', category)
          .map((snapshot) => snapshot.docs
              .map((doc) => WallpaperModel.fromFirestore(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList());
    } catch (e) {
      print('Error streaming wallpapers by category: $e');
      rethrow;
    }
  }

  // ============ WRITE OPERATIONS ============

  /// Add a new wallpaper
  Future<String> addWallpaper(WallpaperModel wallpaper) async {
    try {
      final docRef = await _firebaseService.addDocument(
        collectionName,
        wallpaper.toFirestore(),
      );
      return docRef.id;
    } catch (e) {
      print('Error adding wallpaper: $e');
      rethrow;
    }
  }

  /// Update wallpaper
  Future<void> updateWallpaper(String id, WallpaperModel wallpaper) async {
    try {
      await _firebaseService.updateDocument(
        collectionName,
        id,
        wallpaper.toFirestore(),
      );
    } catch (e) {
      print('Error updating wallpaper: $e');
      rethrow;
    }
  }

  /// Update specific fields of a wallpaper
  Future<void> updateWallpaperFields(
      String id, Map<String, dynamic> fields) async {
    try {
      await _firebaseService.updateDocument(collectionName, id, fields);
    } catch (e) {
      print('Error updating wallpaper fields: $e');
      rethrow;
    }
  }

  /// Increment likes count
  Future<void> incrementLikes(String id) async {
    try {
      await _firebaseService.firestore
          .collection(collectionName)
          .doc(id)
          .update({
        'likes': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing likes: $e');
      rethrow;
    }
  }

  /// Decrement likes count
  Future<void> decrementLikes(String id) async {
    try {
      await _firebaseService.firestore
          .collection(collectionName)
          .doc(id)
          .update({
        'likes': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Error decrementing likes: $e');
      rethrow;
    }
  }

  /// Increment downloads count
  Future<void> incrementDownloads(String id) async {
    try {
      await _firebaseService.firestore
          .collection(collectionName)
          .doc(id)
          .update({
        'downloads': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing downloads: $e');
      rethrow;
    }
  }

  /// Delete wallpaper
  Future<void> deleteWallpaper(String id) async {
    try {
      await _firebaseService.deleteDocument(collectionName, id);
    } catch (e) {
      print('Error deleting wallpaper: $e');
      rethrow;
    }
  }

  /// Get categories
  Future<List<String>> getCategories() async {
    try {
      final querySnapshot = await _firebaseService.getAllDocuments(collectionName);
      final categories = <String>{};

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final category = data['category'] as String?;
        if (category != null && category.isNotEmpty) {
          categories.add(category);
        }
      }

      return categories.toList();
    } catch (e) {
      print('Error getting categories: $e');
      rethrow;
    }
  }
}

