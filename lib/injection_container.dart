import 'package:get_it/get_it.dart';
import 'package:wallpaper_app/core/network/dio_client.dart';
import 'package:wallpaper_app/features/wallpapers/data/data_sources/wallpaper_remote_data_source.dart';
import 'package:wallpaper_app/features/wallpapers/data/repositories/wallpaper_repository_impl.dart';
import 'package:wallpaper_app/features/wallpapers/domain/repositories/wallpaper_repository.dart';
import 'package:wallpaper_app/features/wallpapers/domain/usecases/get_curated_wallpapers.dart';
import 'package:wallpaper_app/features/wallpapers/domain/usecases/search_wallpapers.dart';
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

  // Use cases
  sl.registerLazySingleton(() => GetCuratedWallpapers(sl()));
  sl.registerLazySingleton(() => SearchWallpapers(sl()));

  // Repository
  sl.registerLazySingleton<WallpaperRepository>(
    () => WallpaperRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<WallpaperRemoteDataSource>(
    () => WallpaperRemoteDataSourceImpl(dioClient: sl()),
  );

  // Core / External
  sl.registerLazySingleton(() => DioClient());
}
