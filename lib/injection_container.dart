import 'package:get_it/get_it.dart';
import 'package:wallpaper_app/core/network/dio_client.dart';
import 'package:wallpaper_app/features/wallpapers/data/data_sources/wallpaper_local_data_source.dart';
import 'package:wallpaper_app/features/wallpapers/data/data_sources/wallpaper_remote_data_source.dart';
import 'package:wallpaper_app/features/wallpapers/data/repositories/wallpaper_repository_impl.dart';
import 'package:wallpaper_app/features/wallpapers/domain/repositories/wallpaper_repository.dart';
import 'package:wallpaper_app/features/wallpapers/domain/usecases/add_to_collection.dart';
import 'package:wallpaper_app/features/wallpapers/domain/usecases/get_collection.dart';
import 'package:wallpaper_app/features/wallpapers/domain/usecases/get_curated_wallpapers.dart';
import 'package:wallpaper_app/features/wallpapers/domain/usecases/is_in_collection.dart';
import 'package:wallpaper_app/features/wallpapers/domain/usecases/remove_from_collection.dart';
import 'package:wallpaper_app/features/wallpapers/domain/usecases/search_wallpapers.dart';
import 'package:wallpaper_app/features/wallpapers/presentation/bloc/collection_bloc.dart';
import 'package:wallpaper_app/features/wallpapers/presentation/bloc/wallpaper_bloc.dart';

final sl = GetIt.instance; // Service Locator

Future<void> init() async {
  // Blocs
  sl.registerFactory(
    () => WallpaperBloc(
      getCuratedWallpapers: sl(),
      searchWallpapers: sl(),
    ),
  );
  sl.registerFactory(
    () => CollectionBloc(
      addToCollection: sl(),
      removeFromCollection: sl(),
      getCollection: sl(),
      isInCollection: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCuratedWallpapers(sl()));
  sl.registerLazySingleton(() => SearchWallpapers(sl()));
  sl.registerLazySingleton(() => AddToCollection(sl()));
  sl.registerLazySingleton(() => RemoveFromCollection(sl()));
  sl.registerLazySingleton(() => GetCollection(sl()));
  sl.registerLazySingleton(() => IsInCollection(sl()));

  // Repository
  sl.registerLazySingleton<WallpaperRepository>(
    () => WallpaperRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<WallpaperRemoteDataSource>(
    () => WallpaperRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<WallpaperLocalDataSource>(
    () => WallpaperLocalDataSourceImpl(),
  );

  // Core / External
  sl.registerLazySingleton(() => DioClient());
}
