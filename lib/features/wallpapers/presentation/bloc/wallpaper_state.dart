import 'package:equatable/equatable.dart';
import '../../domain/entities/wallpaper_entity.dart';

abstract class WallpaperState extends Equatable {
  const WallpaperState();

  @override
  List<Object> get props => [];
}

class WallpaperInitial extends WallpaperState {}

class WallpaperLoading extends WallpaperState {
  final List<WallpaperEntity> oldWallpapers;
  final bool isFirstFetch;

  const WallpaperLoading(this.oldWallpapers, {this.isFirstFetch = false});

  @override
  List<Object> get props => [oldWallpapers, isFirstFetch];
}

class WallpaperLoaded extends WallpaperState {
  final List<WallpaperEntity> wallpapers;
  final String category;

  const WallpaperLoaded(this.wallpapers, {this.category = ""});

  @override
  List<Object> get props => [wallpapers, category];
}

class WallpaperError extends WallpaperState {
  final String message;

  const WallpaperError(this.message);

  @override
  List<Object> get props => [message];
}
