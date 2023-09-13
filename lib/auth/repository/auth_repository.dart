import 'package:delivery_app/auth/constants/data.dart';
import 'package:delivery_app/auth/models/login_response.dart';
import 'package:delivery_app/auth/models/token_response.dart';
import 'package:delivery_app/common/dio/dio.dart';
import 'package:delivery_app/common/utils/data_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(baseUrl: 'http://$ip/auth', dio: dio);
});

class AuthRepository {
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.baseUrl,
    required this.dio,
  });

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final serialized = DataUtils.plainToBase64('$username:$password');

    final response = await dio.post(
      '$baseUrl/login',
      options: Options(
        headers: {'Authorization': 'Basic $serialized'},
      ),
    );

    return LoginResponse.fromJson(response.data);
  }

  Future<TokenResponse> token() async {
    final response = await dio.post(
      '$baseUrl/token',
      options: Options(
        headers: {
          'refreshToken': 'true',
        },
      ),
    );

    return TokenResponse.fromJson(response.data);
  }
}
