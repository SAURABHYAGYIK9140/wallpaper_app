import 'package:dio/dio.dart';
import '../constants/AppConstraints.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstraints.BASE_URL,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': '*/*',
        },
      ),
    );


    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Automatically inject API Key
        options.headers['Authorization'] = AppConstraints.API_KEY;
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // Here you could potentially refresh tokens or emit global error streams
        return handler.next(e);
      },
    ));

    // Optional: Add logging interceptor for debug mode
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }
}
