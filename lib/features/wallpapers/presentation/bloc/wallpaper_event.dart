import 'package:equatable/equatable.dart';

abstract class WallpaperEvent extends Equatable {
  const WallpaperEvent();

  @override
  List<Object> get props => [];
}

class GetCuratedEvent extends WallpaperEvent {}

class SearchWallpapersEvent extends WallpaperEvent {
  final String query;

  const SearchWallpapersEvent(this.query);

  @override
  List<Object> get props => [query];
}

class LoadMoreEvent extends WallpaperEvent {}
