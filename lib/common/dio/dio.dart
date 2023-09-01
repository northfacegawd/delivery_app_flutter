import 'package:delivery_app/auth/constants/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  // 1) 요청을 보낼때
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQUEST] [${options.method}] ${options.uri}');
    if (options.headers['accessToken'] == 'true') {
      // accessToken 헤더 삭제
      options.headers.remove('accessToken');
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      // 실제 토큰으로 대체
      options.headers.addAll({'Authorization': 'Bearer $token'});
    }

    if (options.headers['refreshToken'] == 'true') {
      // refreshToken 헤더 삭제
      options.headers.remove('refreshToken');
      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      // 실제 토큰으로 대체
      options.headers.addAll({'Authorization': 'Bearer $token'});
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('[ERROR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken이 없으면 에러를 던짐
    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();
      try {
        final response = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'Authorization': 'Bearer $refreshToken',
            },
          ),
        );
        final options = err.requestOptions;
        final accessToken = response.data['accessToken'];
        options.headers.addAll(
          {'Authorization': 'Bearer $accessToken'},
        );
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        // 요청 재전송
        final retryResponse = await dio.fetch(options);
        return handler.resolve(retryResponse);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }

    // return handler.resolve()

    // 401 에러인 경우 accessToken 재발급 시도
    return super.onError(err, handler);
  }
}
