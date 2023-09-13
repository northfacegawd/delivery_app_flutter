import 'package:delivery_app/user/models/user_model.dart';
import 'package:delivery_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider(ref: ref));

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  // SplashScreen
  String? redirectLogic(GoRouterState state) {
    final user = ref.read(userMeProvider);
    final loggingIn = state.fullPath == '/login';

    if (user == null) {
      return loggingIn ? null : '/login';
    }

    if (user is UserModel) {
      return loggingIn || state.fullPath == '/splash' ? "/" : null;
    }

    if (user is UserModelError) {
      return !loggingIn ? '/login' : null;
    }

    return null;
  }

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }
}
