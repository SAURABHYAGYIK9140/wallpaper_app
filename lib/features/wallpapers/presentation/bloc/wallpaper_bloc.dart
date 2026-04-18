import 'package:flutter_bloc/flutter_bloc.dart';
import 'wallpaper_event.dart';
import 'wallpaper_state.dart';
import '../../domain/entities/wallpaper_entity.dart';
import '../../domain/usecases/get_curated_wallpapers.dart';
import '../../domain/usecases/search_wallpapers.dart';

class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  final GetCuratedWallpapers getCuratedWallpapers;
  final SearchWallpapers searchWallpapers;

  int page = 1;
  String currentCategory = "";

  WallpaperBloc({
    required this.getCuratedWallpapers,
    required this.searchWallpapers,
  }) : super(WallpaperInitial()) {
    on<GetCuratedEvent>((event, emit) async {
      emit(const WallpaperLoading([], isFirstFetch: true));
      page = 1;
      currentCategory = "";
      try {
        final wallpapers = await getCuratedWallpapers(page);
        page++;
        emit(WallpaperLoaded(wallpapers, category: currentCategory));
      } catch (e) {
        emit(WallpaperError(e.toString()));
      }
    });

    on<SearchWallpapersEvent>((event, emit) async {
      emit(const WallpaperLoading([], isFirstFetch: true));
      page = 1;
      currentCategory = event.query;
      try {
        final wallpapers = await searchWallpapers(currentCategory, page);
        page++;
        emit(WallpaperLoaded(wallpapers, category: currentCategory));
      } catch (e) {
        emit(WallpaperError(e.toString()));
      }
    });

    on<LoadMoreEvent>((event, emit) async {
      final currentState = state;
      List<WallpaperEntity> oldWallpapers = [];

      if (currentState is WallpaperLoaded) {
        oldWallpapers = currentState.wallpapers;
      } else if (currentState is WallpaperLoading) {
        // Prevent duplicate load more
        return;
      }

      emit(WallpaperLoading(oldWallpapers, isFirstFetch: false));

      try {
        List<WallpaperEntity> newWallpapers;
        if (currentCategory.isEmpty) {
          newWallpapers = await getCuratedWallpapers(page);
        } else {
          newWallpapers = await searchWallpapers(currentCategory, page);
        }
        page++;
        final allWallpapers = List<WallpaperEntity>.from(oldWallpapers)..addAll(newWallpapers);
        emit(WallpaperLoaded(allWallpapers, category: currentCategory));
      } catch (e) {
        emit(WallpaperError(e.toString()));
      }
    });
  }
}
