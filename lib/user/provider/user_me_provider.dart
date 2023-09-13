import 'package:delivery_app/auth/constants/data.dart';
import 'package:delivery_app/auth/repository/auth_repository.dart';
import 'package:delivery_app/user/models/user_model.dart';
import 'package:delivery_app/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    getMe();
  }

  Future<void> getMe() async {
    final [accessToken, refreshToken] = await Future.wait([
      storage.read(key: ACCESS_TOKEN_KEY),
      storage.read(key: REFRESH_TOKEN_KEY),
    ]);

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    state = await repository.getMe();
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final response = await authRepository.login(
        username: username,
        password: password,
      );

      await Future.wait([
        storage.write(key: ACCESS_TOKEN_KEY, value: response.accessToken),
        storage.write(key: REFRESH_TOKEN_KEY, value: response.refreshToken),
      ]);

      final userResponse = await repository.getMe();

      state = userResponse;

      return userResponse;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했씁니다.');
      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    await Future.wait([
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY)
    ]);
  }
}
