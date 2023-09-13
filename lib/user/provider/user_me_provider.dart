import 'package:delivery_app/auth/constants/data.dart';
import 'package:delivery_app/user/models/user_model.dart';
import 'package:delivery_app/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
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
}
