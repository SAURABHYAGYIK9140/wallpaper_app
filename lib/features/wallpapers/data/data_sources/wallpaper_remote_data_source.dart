import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/wallpaper_model.dart';

abstract class WallpaperRemoteDataSource {
  Future<List<WallpaperModel>> getCuratedWallpapers(int page, {int perPage = 10});
  Future<List<WallpaperModel>> searchWallpapers(String query, int page, {int perPage = 10});
}

class WallpaperRemoteDataSourceImpl implements WallpaperRemoteDataSource {
  final DioClient dioClient;

  WallpaperRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<WallpaperModel>> getCuratedWallpapers(int page, {int perPage = 10}) async {
    try {
      final response = await dioClient.dio.get(
        "curated",
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      if (response.statusCode == 200) {
        final List photos = response.data['photos'];
        return photos.map((e) => WallpaperModel.fromJson(e)).toList();
      } else {
        throw ServerException(
          message: 'Failed to load curated wallpapers from server',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException(message: 'Invalid API Key');
      }
      throw ServerException(
        message: e.message ?? 'Unknown Dio Error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<WallpaperModel>> searchWallpapers(String query, int page, {int perPage = 10}) async {
    try {
      final response = await dioClient.dio.get(
        "search",
        queryParameters: {
          'query': query,
          'page': page,
          'per_page': perPage,
        },
      );

      if (response.statusCode == 200) {
        final List photos = response.data['photos'];
        return photos.map((e) => WallpaperModel.fromJson(e)).toList();
      } else {
        throw ServerException(
          message: 'Failed to search wallpapers from server',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException(message: 'Invalid API Key');
      }
      throw ServerException(
        message: e.message ?? 'Unknown Dio Error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
