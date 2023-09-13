import 'package:delivery_app/common/provider/go_router.dart';
import 'package:delivery_app/common/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: _App()));
}

class _App extends ConsumerWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routeProvider);
    return MaterialApp.router(
      theme: ThemeData(fontFamily: 'NotoSansKR'),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
