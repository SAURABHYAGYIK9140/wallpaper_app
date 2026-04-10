class WallpaperModel {
  final String? id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String photographer;
  final int downloads;
  final int likes;
  final double rating;
  final DateTime createdAt;
  final bool isFavorite;
  final String tags;

  WallpaperModel({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.photographer,
    this.downloads = 0,
    this.likes = 0,
    this.rating = 0.0,
    required this.createdAt,
    this.isFavorite = false,
    this.tags = '',
  });

  // Convert Firestore document to WallpaperModel
  factory WallpaperModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return WallpaperModel(
      id: docId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      photographer: data['photographer'] ?? '',
      downloads: data['downloads'] ?? 0,
      likes: data['likes'] ?? 0,
      rating: (data['rating'] ?? 0.0).toDouble(),
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      isFavorite: data['isFavorite'] ?? false,
      tags: data['tags'] ?? '',
    );
  }

  // Convert WallpaperModel to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'photographer': photographer,
      'downloads': downloads,
      'likes': likes,
      'rating': rating,
      'createdAt': createdAt,
      'isFavorite': isFavorite,
      'tags': tags,
    };
  }

  // Create a copy with modified fields
  WallpaperModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? category,
    String? photographer,
    int? downloads,
    int? likes,
    double? rating,
    DateTime? createdAt,
    bool? isFavorite,
    String? tags,
  }) {
    return WallpaperModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      photographer: photographer ?? this.photographer,
      downloads: downloads ?? this.downloads,
      likes: likes ?? this.likes,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() {
    return 'WallpaperModel(id: $id, title: $title, category: $category, likes: $likes)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WallpaperModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

